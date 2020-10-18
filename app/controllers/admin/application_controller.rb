class Admin::ApplicationController < ApplicationController
  layout 'admin/layouts/application'

  before_action :ensure_role!

  private

  def ensure_role!
    raise CanCan::AccessDenied if current_user.visitor?
  end
end
