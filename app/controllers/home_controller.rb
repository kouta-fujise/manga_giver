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
end
