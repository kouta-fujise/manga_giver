class UserController < ApplicationController

  before_action :authenticate_user, {only:[:page,:give,:pay,:ad_setting]}
  before_action :forbid_login_user, {only:[:register,:login,:create,:logion_form]}

  def give
    @gives = Give.where(user_id:@current_user).where(done:1)
  end

  def get
    @gets = Give.where(target_id:@current_user).where(done:1)
  end

  def register
    @user  = User.new
  end

  def create
    if params[:password1] != params[:password2]
      flash[:notice] = "確認用パスワードが一致していません"
      @user = User.new(
        email: params[:email],
        password: params[:password1]
      )
      render("user/register")
    else
      @user = User.new(
        email: params[:email],
        password: params[:password1],
      )
      if @user.save
        flash[:notice] = "アカウントを作成しました"
        session[:user_id] = @user.id
        redirect_to("/")
      else
        render("user/register")
      end
    end
  end

  def login
    @user  = User.new
  end

  def login_form
    @user = User.find_by(email: params[:email])
    if @user && @user.authenticate(params[:password])
      flash[:notice] = "ログインしました"
      session[:user_id] = @user.id
      redirect_to("/")
    else
      @error_message = "メールアドレスまたはパスワードが間違っています"
      @user = User.new(
        email: params[:email],
        password: params[:password]
      )
      render("user/login")
    end
  end

  def name_set
    @user = @current_user
  end

  def name
    @user =  @current_user
    if params[:name]==""
      flash[:notice] = "ユーザ名が入力されていません"
      render("user/name_set")
    else
      @user.name = params[:name]
      if @user.save
        flash[:notice] = "ユーザ名を登録しました"
        redirect_to("/user/name_set")
      else
        render("user/name_set")
      end
    end
  end

  def email
    @user =  @current_user
    if params[:email]==""
      flash[:notice] = "メールアドレスが入力されていません"
      render("user/name_set")
    else
      @user.email = params[:email]
      if @user.save
        flash[:notice] = "メールアドレスを登録しました"
        redirect_to("/user/name_set")
      else
        render("user/name_set")
      end
    end
  end

  def password
    @user =  @current_user
    if params[:password]==""
      flash[:notice] = "パスワードが入力されていません"
      render("user/name_set")
    else
      @user.password = params[:password]
      if @user.save
        flash[:notice] = "パスワードを登録しました"
        redirect_to("/user/name_set")
      else
        render("user/name_set")
      end
    end
  end

  def ad_set
    @user =  @current_user
  end

  def address #住所変更関数
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
      redirect_to("/user/ad_set")
    else
      render("user/ad_set")
    end
  end


  def logout
    if session[:user_id] == nil
      flash[:notice] = "ログインしていません"
      redirect_to("/")
    else
      flash[:notice] = "ログアウトしました"
      session[:user_id] = nil
      redirect_to("/")
    end
  end

  def page
    @user = @current_user
    # オファー枠表示

    # 取引履歴表示
    @gives = Give.where(user_id:@current_user).where(done:1)
    # @gets = Give.where(target_id:@current_user).where(done:1)
    # ユーザーidがcurrent_userと同じもののうち、receivedがnilもしくは1ではないのもの
    @not_receive = Offer.where(user_id:@current_user).where(done:1).where(received:nil).or(Offer.where(user_id:@current_user).where(done:1).where.not(received:1))
    # logger.debug("未受け取りの漫画")
    # logger.debug @not_receive
    # 送った相手の人数をpersons_given_numとして計算
    @persons_given = []# persons_givenにtarget_idを保存していく
    @persons_given_num = 0
    @gives.each do |give|
      # persons_givenに同じtarget_idがあればカウントしない
      if @persons_given.find{ |n| n == give.target_id}

      else #同じtarget_idがなければ、追加してnumを加算
        @persons_given.push(give.target_id)
        @persons_given_num += 1
      end
    end
    # ランクのプログレスバーの表示
    @progress = @user.total_amount_paid * 100 / @rank_border[@rank_num +1]

    # カードの登録有無
    Payjp.api_key = ENV["PAYJP_SECRET_KEY"] # PAY.JPに秘密鍵を使ってアクセス
    # 今のユーザのカード情報からtokenが入っているものを全て取得
    @cards = Card.where(user_id: @current_user.id).where.not(token_id: nil)


  end

  def pay
    @user = @current_user

  end

  def deal
    @not_receive = Offer.where(user_id:@current_user).where(done:1).where(received:nil).or(Offer.where(user_id:@current_user).where(done:1).where.not(received:1))
  end



end
