SamlIdp.configure do |config|
  base = Rails.application.credentials.dig(:apps, :idp, :url)

  config.x509_certificate = Rails.application.credentials.dig(:saml, :certificate)
  config.secret_key = Rails.application.credentials.dig(:saml, :secret_key)

  config.algorithm = :sha256
  config.base_saml_location = "#{base}/saml"
  config.single_service_post_location = "#{base}/saml/auth"

  # NameIDFormat
  config.name_id.formats = {
    email_address: -> (principal) { principal.email },
    transient: -> (principal) { principal.uid },
    persistent: -> (principal) { principal.uid }
  }

  config.attributes = {
    'Given name': {
      name: 'first_name',
      name_format: 'urn:oasis:names:tc:SAML:2.0:attrname-format:basic',
      getter: :first_name
    },
    'Family name': {
      name: 'last_name',
      name_format: 'urn:oasis:names:tc:SAML:2.0:attrname-format:basic',
      getter: :last_name
    },
    'Email address': {
      name: 'email',
      name_format: 'urn:oasis:names:tc:SAML:2.0:attrname-format:basic',
      getter: :email
    },
    'Blog role': {
      name: 'blog_role',
      name_format: 'urn:oasis:names:tc:SAML:2.0:attrname-format:basic',
      getter: :blog_role
    },
    'Video role': {
      name: 'video_role',
      name_format: 'urn:oasis:names:tc:SAML:2.0:attrname-format:basic',
      getter: :video_role
    }
  }

  fingerprint = Rails.application.credentials.dig(:saml, :fingerprint)
  service_providers = [:blog, :video].map { |app_name|
    metadata_url = "#{Rails.application.credentials.dig(:apps, app_name, :url)}/users/auth/saml/metadata"
    [
      metadata_url,
      { fingerprint: fingerprint, metadata_url: metadata_url }
    ]
  }.to_h

  # `identifier` is the entity_id or issuer of the Service Provider,
  # settings is an IncomingMetadata object which has a to_h method that needs to be persisted
  config.service_provider.metadata_persister = -> (identifier, settings) {
    fname = identifier.to_s.gsub(/\/|:/,"_")
    FileUtils.mkdir_p(Rails.root.join('cache', 'saml', 'metadata').to_s)
    File.open Rails.root.join("cache/saml/metadata/#{fname}"), "r+b" do |f|
      Marshal.dump settings.to_h, f
    end
  }

  # `service_provider` is a ServiceProvider object. Based on the `identifier` or the
  # `service_provider` you should return the settings.to_h from above
  config.service_provider.persisted_metadata_getter = -> (identifier, service_provider) {
    fname = identifier.to_s.gsub(/\/|:/,"_")
    FileUtils.mkdir_p(Rails.root.join('cache', 'saml', 'metadata').to_s)
    full_filename = Rails.root.join("cache/saml/metadata/#{fname}")
    if File.file?(full_filename)
      File.open full_filename, "rb" do |f|
        Marshal.load f
      end
    end
  }

  # Find ServiceProvider metadata_url and fingerprint based on our settings
  config.service_provider.finder = -> (issuer_or_entity_id) do
    service_providers[issuer_or_entity_id]
  end
end
