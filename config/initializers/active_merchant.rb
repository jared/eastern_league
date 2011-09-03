if Rails.env.production?
  ActiveMerchant::Billing::Base.gateway_mode = :test
  ActiveMerchant::Billing::Base.integration_mode = :test
  ActiveMerchant::Billing::PaypalGateway.pem_file =
  File.read(File.dirname(__FILE__) + '/../paypal/paypal_cert.pem')
else
  ActiveMerchant::Billing::Base.gateway_mode = :test
  ActiveMerchant::Billing::Base.integration_mode = :test
  ActiveMerchant::Billing::PaypalGateway.pem_file =
  File.read(File.dirname(__FILE__) + '/../paypal/sandbox_paypal_cert.pem')

  # These values are used by the ElCrypto library.
  PAYPAL_ACTION_URL   = "https://www.sandbox.paypal.com/uk/cgi-bin/webscr"

  PUBLIC_CERTIFICATE  = "#{Rails.root}/config/paypal/el-dev-pubcert.pem"
  PRIVATE_KEY         = "#{Rails.root}/config/paypal/el-dev-prvkey.pem"
  PAYPAL_CERTIFICATE  = "#{Rails.root}/config/paypal/sandbox_paypal_cert.pem"
  PAYPAL_CERT_ID      = "92RX5FFSRK354"
  PAYPAL_USER_ACCOUNT = "elsell_1315075565_biz@gmail.com"
end