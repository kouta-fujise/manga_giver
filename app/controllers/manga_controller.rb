class MangaController < ApplicationController


  def top
  end

  def index

    @mangas = Manga.all
  end

  def page
    if params[:id].present?
      @manga = Manga.find_by(id:params[:id])
      $current_manga = @manga
    end
  end

  def give
  end

  def togive
  end

  def toget
  end

  def pay
   @manga = @@current_manga
   Payjp.api_key = ENV['PAYJP_PRIVATE_KEY']
   charge = Payjp::Charge.create(
   amount: @manga.price,
   card: params['payjp-token'],
   currency: 'jpy'
   )
   flash[:notice] = "支払い完了しました。"

   redirect_to("/manga/#{@manga.id}")
 end

 def fakepay
   @manga = $current_manga

   @give = Give.new(
     user_id: @current_user.id,
     manga_id: @manga.id,
     price: @manga.price,
     done: 0,
   )
   if @give.save
     @notyetoffers = Offer.where(manga_id: @manga.id).where(done: 0)
     if @notyetoffers == []
       flash[:notice] = "支払いが完了しました"
       redirect_to("/manga/#{@manga.id}")
     else
     # @nyo_user_id =[]
     # @notyetoffers.each do |offer|
     #   @nyo_user_id.push(offer.user_id)
     # end
     # @nyo_user_id.sample
    @selectoffer = @notyetoffers.sample
    @selectoffer.given_by = @give.user_id
    @selectoffer.done = 1
    @selectoffer.save

    @give.done = 1
    @give.target_id = @selectoffer.user_id
    @give.save

   flash[:notice] = "#{@selectoffer.user_id}さんに奢りました"
   redirect_to("/manga/#{@manga.id}")
     end
   end
 end


  def offer
    @manga = $current_manga
    # オファーの中にこのユーザのオファーかつ受け取っていないものがあるかどうか
    if Offer.find_by(user_id:@current_user.id,done:0).nil?
      # ないならオファーできる
      @offer = Offer.new(
        user_id: @current_user.id,
        manga_id: @manga.id,
        done: 0,
      )
      if @offer.save
        @notyetgives = Give.where(manga_id: @manga.id).where(done: 0)
        if @notyetgives == []
          flash[:notice] = "オファー完了しました。"
          redirect_to("/manga/#{@manga.id}")
        else
          @selectgive = @notyetgives.sample
          @selectgive.target_id = @offer.user_id
          @selectgive.done = 1
          @selectgive.save

          @offer.done = 1
          @offer.given_by = @selectgive.user_id
          @offer.save

          flash[:notice] = "#{@selectgive.user_id}さんから頂きました"
          redirect_to("/manga/#{@manga.id}")
        end
      end
    else
      # あるならできない
      flash[:notice] = "オファー枠がありません。既に他の漫画をオファーしています"
      redirect_to "/manga/#{@manga.id}"
    end
  end

  def deal
    @gives = Give.where(done:1)
    @mangas = Manga.all
    @users = User.all
  end

  def notyet
    @gives = Give.where(done:1).where(complete:nil)
    @mangas = Manga.all
    @users = User.all
  end

  def complete
    @give = Give.find_by(id:params[:id])
    @give.complete = 1
    @give.save

    flash[:notice] = "#{@give.id}番取引完了しました"
    redirect_to("/manga/deal")
  end

  def register
    @manga = Manga.new
  end


  def insert
    @manga = Manga.new(
      name: params[:name],
      author: params[:author],
      image: params[:image],
      text: params[:text],
      price: params[:price],
    )
    if @manga.save
      flash[:notice] = "漫画を新規登録しました"
      redirect_to("/manga/register")
    else
      flash[:notice] = "登録できませんでした"
      render("manga/register")
    end
  end

end
