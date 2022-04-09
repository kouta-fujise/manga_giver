class UserController < ApplicationController

  before_action :authenticate_user, {only:[:page,:give,:pay,:ad_setting]}
  before_action :forbid_login_user, {only:[:register,:login,:create,:logion_form]}

  def give
  end

  def register
    @user  = User.new
  end

  def create

    @user = User.new(
      email: params[:email],
      password: params[:password],
    )

    if @user.save
      flash[:notice] = "アカウントを作成しました"
      session[:user_id] = @user.id
      redirect_to("/")
    else
      render("user/register")
    end
  end

  def login
  end

  def login_form
    @user = User.find_by(email: params[:email])
    if @user && @user.authenticate(params[:password])
      flash[:notice] = "ログインしました"
      session[:user_id] = @user.id
      redirect_to("/")
    else
      @error_message = "メールアドレスまたはパスワードが間違っています"
      render("user/login")
    end
  end

  def address
    # 住所が入力されてない時も通ってしまう
    @user =  @current_user
    @user.address = params[:address1]+" "+params[:address2]+" "+params[:address3]+" "+params[:address4]+" "+params[:address5]+" "+params[:address6]
    @user.address1 = params[:address1]
    @user.address2 = params[:address2]
    @user.address3 = params[:address3]
    @user.address4 = params[:address4]
    @user.address5 = params[:address5]
    @user.address6 = params[:address6]
    if @user.save
      flash[:notice] = "住所を登録しました"
      redirect_to("/")
    else
      render("user/setting")
    end
  end


  def logout
    flash[:notice] = "ログアウトしました"
    session[:user_id] = nil
    redirect_to("/")
  end

  def page
    @user = @current_user
  end

  def pay
    @user = @current_user

  end

end
