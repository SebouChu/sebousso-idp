class SamlIdpController < SamlIdp::IdpController
  before_action :authenticate_user!, except: :show

  # Make sure to set both GET & POST requests to /saml/auth to #create
  def create
    @saml_response = idp_make_saml_response(current_user)
    render 'saml_idp/idp/saml_post', layout: false
  end

  private

  def idp_make_saml_response(user)
    encode_response(user)
  end
end