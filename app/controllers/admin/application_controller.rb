class Admin::ApplicationController < ApplicationController
  before_action :ensure_role!

  private

  def ensure_role!
    raise CanCan::AccessDenied unless current_user.admin?
  end
end
