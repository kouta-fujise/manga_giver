class HomeController < ApplicationController
  def top
    @mangas = Manga.all
  end
end
