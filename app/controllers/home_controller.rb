class HomeController < ApplicationController
  def top
    @mangas = Manga.all
  end

  def admin

  end

  def admin_login
    if params[:id] == ENV["ADMIN_ID"] && params[:password] == ENV["ADMIN_PASS"]
      $admin = 1
      flash[:notice] = "管理者でログインしました"
      redirect_to "/manga/deal"
    else
      flash[:notice] = "idかパスワードが一致していません"
      render("admin")
    end
  end

  def admin_logout
    $admin = 0
    flash[:notice] = "管理者からログアウトしました"
    redirect_to "/"
  end

  def dashboard
    @users = User.all
    @gives = Give.all

    # 累計売り上げ、販売冊数の計算
    @give_amount = 0
    @give_volume =0
    @deal_count =0
    @gives.each do |give|
      @give_amount += give.amount
      @give_volume += give.volume
      if give.done ==1
        @deal_count += 1
      end
    end

    @offer = Offer.all
    @manga = Manga.all
  end
end
