EasternLeague::Application.configure do
  # Settings specified here will take precedence over those in config/application.rb


    # Code is not reloaded between requests.
    config.cache_classes = true

    # Eager load code on boot. This eager loads most of Rails and
    # your application in memory, allowing both thread web servers
    # and those relying on copy on write to perform better.
    # Rake tasks automatically ignore this option for performance.
    config.eager_load = true

    # Full error reports are disabled and caching is turned on.
    config.consider_all_requests_local       = false
    config.action_controller.perform_caching = true

    # Enable Rack::Cache to put a simple HTTP cache in front of your application
    # Add `rack-cache` to your Gemfile before enabling this.
    # For large-scale production use, consider using a caching reverse proxy like nginx, varnish or squid.
    # config.action_dispatch.rack_cache = true

    # Disable Rails's static asset server (Apache or nginx will already do this).
    config.serve_static_files = true

    # Compress JavaScripts and CSS.
    config.assets.js_compressor = :uglifier
    # config.assets.css_compressor = :sass

    # Do not fallback to assets pipeline if a precompiled asset is missed.
    config.assets.compile = false

    # Generate digests for assets URLs.
    config.assets.digest = true

  # Specifies the header that your server uses for sending files
  # (comment out if your front-end server doesn't support this)
  config.action_dispatch.x_sendfile_header = "X-Sendfile" # Use 'X-Accel-Redirect' for nginx

  # Force all access to the app over SSL, use Strict-Transport-Security, and use secure cookies.
  # config.force_ssl = true

  # See everything in the log (default is :info)
  # config.log_level = :debug
  config.log_level = :info

  # Use a different logger for distributed setups
  # config.logger = SyslogLogger.new

  # Use a different cache store in productiona
  # config.cache_store = :mem_cache_store

  # Enable serving of images, stylesheets, and JavaScripts from an asset server
  # config.action_controller.asset_host = "http://assets.example.com"

  # Precompile additional assets (application.js, application.css, and all non-JS/CSS are already added)
  # config.assets.precompile += %w( hideshow.js )

  # Disable delivery errors, bad email addresses will be ignored
  # config.action_mailer.raise_delivery_errors = false
  config.action_mailer.default_url_options = {
    :host => "easternleague.net"
  }

  # Enable threaded mode
  # config.threadsafe!

  # Enable locale fallbacks for I18n (makes lookups for any locale fall back to
  # the I18n.default_locale when a translation can not be found)
  config.i18n.fallbacks = true

  # Send deprecation notices to registered listeners
  config.active_support.deprecation = :notify

end

EasternLeague::Application.config.middleware.use ExceptionNotifier,
  :email_prefix         => "[ELSKA] ",
  :sender_address       => %{"EL Website" <elcommissioner@gmail.com>},
  :exception_recipients => %w{jared@alloycode.com},
  :ignore_crawlers      => %w{Googlebot bingbot}

