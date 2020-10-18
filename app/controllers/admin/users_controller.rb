class Admin::UsersController < Admin::ApplicationController
  load_and_authorize_resource find_by: :uid, id_param: :uid

  def index
  end

  def show
  end

  def new
  end

  def edit
  end

  def create
    if @user.save
      redirect_to [:admin, @user], notice: 'User was successfully created.'
    else
      byebug
      render :new
    end
  end

  def update
    manage_password
    if @user.update(user_params)
      redirect_to [:admin, @user], notice: 'User was successfully updated.'
    else
      render :edit
    end
  end

  def destroy
    @user.destroy
    redirect_to admin_users_path, notice: 'User was successfully destroyed.'
  end

  private

  def user_params
    params.require(:user).permit(
      :first_name, :last_name, :email, :password,
      :role, :blog_role, :video_role
    )
  end

  def manage_password
    params[:user][:password] ||= ''

    if params[:user][:password].blank?
      params[:user].delete(:password)
    else
      @user.reset_password(params[:user][:password], params[:user][:password])
    end
  end
end
