class ApplicationController < ActionController::Base

  before_action :set_current_user

  def set_current_user
    @current_user = User.find_by(id: session[:user_id])

    if @current_user

      # ユーザーのランク計測
      @rank_border = [0,10000,50000,100000]
      @ranks = ["ビギナー","ブロンズ","シルバー","ゴールド","プラチナ"]

      total = @current_user.total_amount_paid
      # 0ならビギナー
      if total == 0
        @rank_num = 0
        @rank = @ranks[0]
      else
        for n in 1..@ranks.size do
          if total >= @rank_border[n-2]
            @rank_num = n-1
            @rank = @ranks[n-1]
          end
        end
      end
      # ユーザーのオファー枠計測
      # 取引未成立のオファーがあるかどうか
      offer = Offer.find_by(user_id:@current_user.id,done:0)
      # あるなら0
      if offer
        @offer_point = 0;
        @current_offer = offer
      # 全て成立済みなら1
      else
        @offer_point = 1;
      end
      logger.debug @offer_point

    end #if @current_user

  end

  def authenticate_user
    if @current_user == nil
      flash[:notice]  = "ログインが必要です"
      redirect_to("/login")
    end
  end

  def forbid_login_user
    if @current_user
      flash[:notice] = "すでにログインしています"
      redirect_to("/")
    end
  end

end
