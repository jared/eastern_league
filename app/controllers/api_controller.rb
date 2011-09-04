class ApiController < ApplicationController
  include ActiveMerchant::Billing::Integrations

  def ipn
    @notify = Paypal::Notification.new(request.raw_post)

    File.open("#{Rails.root}/log/paypal_ipn.log", "a+") { |f| f.write "#{request.raw_post}\n" }

    unless Order.count("*", :conditions => ["paypal_transaction_identifier = ?", @notify.transaction_id]).zero?
      logger.warn("Multiple Payments received for #{@notify.transaction_id}")
    end

    @order = Order.find(@notify.invoice)

    if @notify.acknowledge
      begin
        if @notify.complete?
          attrs = {
            :state                         => "IPN Received",
            :paypal_transaction_identifier => @notify.transaction_id,
            :paypal_status                 => @notify.status,
            :paypal_fee                    => @notify.fee
          }
          @order.line_items.each do |line_item|
            case line_item.purchasable.class
            when Membership
              line_item.purchasable.activate!
            else
              logger.warn("I don't know what to do with this line item #{line_item.id}")
            end
          end
          @order.update_attributes!(attrs)
        else
          @order.update_attribute(:paypal_status, @notify.status)
          logger.warn("#{@notify.transaction_id} was not complete.")
          raise "Payment not completed."
        end

      rescue => e
        raise e
      end
    else
      @order.update_attributes(:status => "Conflicted", :paypal_status => @notify.status)
      logger.warn("#{@notify.transaction_id} was not acknowledged.")
      raise "Payment not acknowledged."
    end
    render :nothing => true
  end

end
