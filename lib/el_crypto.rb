module ElCrypto

  class EncryptedOrder
    include Rails.application.routes.url_helpers
    attr_accessor :encrypted_data, :decrypted_data

    def initialize(order)
      raise ActiveRecord::RecordNotSaved if order.new_record?

      @decrypted_data = {
        # Item name and number are displayed to the user making the payment, and can be customized.
        :item_name      => "Eastern League Membership",
        :item_number    => order.id,

        :amount         => order.amount,

        # Custom and Invoice are fields which are sent BACK to our API through the IPN call.
        # Invoice is essential, as it is used to look up the invoice to mark as paid (or any other status)
        :custom         => "Membership successfully purchased.",
        :invoice        => order.id,

        # Paypal-required values, edit constants in config/initializers/active_merchant.rb
        :cmd            => "_xclick",
        :cert_id        => PAYPAL_CERT_ID,
        :business       => PAYPAL_USER_ACCOUNT,

        :currency_code  => "USD",
        :country        => "US",
        :no_note        => "1",
        :no_shipping    => "1",

        # Return specifies the location where a user is bounced back to after paying on Paypal's site.
        :return         => thank_you_user_order_url(order.user, order, :host => RETURN_HOST),

        # TODO: Update these with more aesthetically pleasing values.
        :cpp_header_image     => "http://easternleague.net/images/ELNewLogo.gif", # Large format logo
        :image_url            => "http://easternleague.net/images/ELNewLogo.gif", # Small format logo
        :cpp_headerback_color => "F7F8F8",                                  # Header background color
        :cbt                  => "Return to the Eastern League",            # Button text when payment is complete, to return to INSERT_BRAND_NAME
      }
      @encrypted_data = encrypt_data(@decrypted_data)
    end

    def encrypt_data(data)
      temp_encrypted_data = ""

      # The following are defined in config/initializers/active_merchant.rb
      my_cert_file = PUBLIC_CERTIFICATE
      my_key_file = PRIVATE_KEY
      paypal_cert_file = PAYPAL_CERTIFICATE

      IO.popen("/usr/bin/openssl smime -sign -signer #{my_cert_file} -inkey #{my_key_file} -outform der -nodetach -binary | /usr/bin/openssl smime -encrypt -des3 -binary -outform pem #{paypal_cert_file}", 'r+') do |pipe|
        data.each { |x,y| pipe << "#{x}=#{y}\n" }
        pipe.close_write
        temp_encrypted_data = pipe.read.gsub!(/\n/,"")
      end
      temp_encrypted_data
    end
  end

end