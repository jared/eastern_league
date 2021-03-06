class ApiController < ApplicationController
  include OffsitePayments::Integrations
  
  def ipn
    @commissioner = User.find(AdminSetting.first.commissioner_user_id)  

    @notify = Paypal::Notification.new(request.raw_post)
    File.open("#{Rails.root}/log/paypal_ipn.log", "a+") { |f| f.write "#{Time.now.to_s(:db)}: #{request.raw_post}\n" }

    unless Order.where("paypal_transaction_identifier = ?", @notify.transaction_id).count("*").zero?
      logger.warn("Multiple Payments received for #{@notify.transaction_id}")
    end

    @order = Order.find_by_id(@notify.invoice)
    if @order.nil?
      File.open("#{Rails.root}/log/paypal_ipn.log", "a+") { |f| f.write "#{Time.now.to_s(:db)}: No order found for #{@notify.inspect}" }
      UserMailer.user_message(@commissioner, @commissioner, "API Controller: No order found for #{@notify.inspect}").deliver_now
      render nothing: true and return
    end

    if @notify.acknowledge
      if @notify.complete?
        attrs = {
          state:                         "IPN Received",
          paypal_transaction_identifier: @notify.transaction_id,
          paypal_status:                 @notify.status,
          paypal_fee:                    @notify.fee
        }
        @order.line_items.each do |line_item|
          case line_item.purchasable.class.name
          when "Membership"
            line_item.purchasable.activate!
          when "EventRegistration"
            line_item.purchasable.update_attribute(:paid, true)
            UserMailer.event_registration(line_item.purchasable).deliver unless line_item.purchasable.competitor.user.temporary_email?
          else
            logger.warn("I don't know what to do with this line item #{line_item.id}")
          end
        end
        @order.update_attributes!(attrs)
      else
        @order.update_attribute(:paypal_status, @notify.status)
        logger.warn("#{@notify.transaction_id} was not complete.")
        UserMailer.user_message(@commissioner, @commissioner, "API Controller: #{@notify.inspect}").deliver_now
        render nothing: true and return
      end
    else
      @order.update_attributes(state: "Conflicted", paypal_status: @notify.status)
      logger.warn("#{@notify.transaction_id} was not acknowledged.")
      raise "Payment not acknowledged."
    end
    render nothing: true
  end

end
