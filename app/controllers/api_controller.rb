class ApiController < ApplicationController
  include ActiveMerchant::Billing::Integrations

  def ipn
    @notify = Paypal::Notification.new(request.raw_post)
    # TODO: Turn off IPN logging when unnecessary.
    File.open("#{Rails.root}/log/paypal_ipn.log", "a+") { |f| f.write "#{request.raw_post}\n" }
    unless Order.count("*", :conditions => ["paypal_transaction_identifier = ?", @notify.transaction_id]).zero?
      logger.warn("Multiple Payments received for #{@notify.transaction_id}")
    end

    @order = Order.find(@notify.invoice)

    if @notify.acknowledge
      begin
        if @notify.complete?
          attrs = {
            :status => "IPN Received",
            :paypal_transaction_identifier => @notify.transaction_id,
            :paypal_status => @notify.status,
            :paypal_fee    => @notify.fee
          }
          # TODO: 'complete' membership record by setting expirations, updating user, etc
          @order.update_attributes!(attrs)
        else
          @order.update_attribute(:paypal_status, @notify.status)
          raise "Payment not completed."
        end

      rescue => e
        raise e
      ensure
        #make sure we logged everything we must
      end
    else
      @order.update_attributes(:status => "Conflicted", :paypal_status => @notify.status)
      raise "Payment not acknowledged."

  end

end
