class MangaController < ApplicationController


  def top
  end

  def index

    @mangas = Manga.all
  end

  def page
    if Manga.find_by(id:params[:id])
      @manga = Manga.find_by(id:params[:id])
      $current_manga = @manga
    else
      redirect_to("/")
    end
    # 登録済みカードの取得
    Payjp.api_key = ENV["PAYJP_SECRET_KEY"] # PAY.JPに秘密鍵を使ってアクセス
    # card = Card.find_by(user_id: @current_user.id) # cardsテーブルからユーザーのカード情報を取得
    # 今のユーザのカード情報からtokenが入っているものを全て取得
    card = Card.where(user_id: @current_user.id).where.not(token_id: nil)
    # card = Card.where(user_id: @current_user.id)# cardsテーブルからユーザーのカード情報を取得
    # logger.debug("cardはこれ")
    # logger.debug card.inspect
    # 取得したカード全ての顧客情報を取得
    customer = []
    card.each do |card_each|
      customer.push(Payjp::Customer.retrieve(card_each.customer_id))# 顧客idを元に、顧客情報を取得
      # logger.debug("cunstomerはこれ")
      # logger.debug customer.inspect
    end
    # 取得した全ての顧客情報からカード情報を取得
    @card = []
    customer.each do |customer_each|
    @card.push(customer_each.cards.first)
    # logger.debug("@cardはこれ")
    # logger.debug @card.inspect
    end

  end

  def give
  end

  def togive
  end

  def toget
  end

  # def pay
  #   @manga = $current_manga
  #   price = @manga.price*@manga.volume
  #   Payjp.api_key = ENV['PAYJP_SECRET_KEY']
  #   charge = Payjp::Charge.create(
  #     amount: price,
  #     card: params['payjp-token'],
  #     currency: 'jpy'
  #   )
  #   # @give = Give.new(
  #   #   user_id: @current_user.id,
  #   #   manga_id: @manga.id,
  #   #   price: @manga.price,
  #   #   done: 0,
  #   # )
  #   flash[:notice] = "支払い完了しました。"
  #
  #   redirect_to("/manga/#{@manga.id}")
  # end

  def card_pay
    @manga = $current_manga
    price = @manga.price*@manga.volume
    Payjp.api_key = ENV['PAYJP_SECRET_KEY']
    # カードを選ぶバージョン paramsで持ってくる
    logger.debug("カスタマーid")
    logger.debug params[:customer_id]
    if params[:customer_id].present?
      charge = Payjp::Charge.create(
        amount: price,
        customer: params[:customer_id],
        currency: 'jpy'
      )
    else
      flash[:notice] = "カードが選択されていません。"
      redirect_to("/manga/#{@manga.id}")
    end
    # カードを選ばないバージョン
    #   logger.debug("今のユーザ")
    #   logger.debug @current_user.inspect
    # card = Card.where(user_id: @current_user.id).where.not(token_id: nil) # cardsテーブルからユーザーのカード情報を取得
    #   logger.debug("カード")
    #   logger.debug card.inspect
    # customer_id = []
    # card.each do |card_each|
    #   customer_id.push(card_each.customer_id)
    # end
    #   logger.debug("カスタマーid")
    #   logger.debug customer_id.inspect
    #   logger.debug("カスタマーidの先頭")
    #   logger.debug customer_id.first
    # charge = Payjp::Charge.create(
    #   amount: price,
    #   customer: customer_id.first,
    #   currency: 'jpy'
    # )

    # 取引データ書き込み
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
        @selectoffer = @notyetoffers.sample #sampleでランダムに選んでいる
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

  def create_pay
    # create部分
    existing_card = Card.where(user_id: @current_user.id).where.not(token_id: nil)
    if existing_card.size > 2
      flash[:notice] = "カードは3枚まで登録できます"
      redirect_to "/user/page"
    end
    Payjp.api_key = ENV["PAYJP_SECRET_KEY"]
    customer = Payjp::Customer.create(
      description: 'test',
      card: params[:token_id]
    )
    # customerオブジェクトとカードトークンをcardテーブルに保存する。
    card = Card.new(
      customer_id: customer.id,
      token_id: params[:token_id],
      user_id: @current_user.id
    )
    if card.save #カードが登録できたらpay部分に進む。

    else
      # カードの登録に失敗
      flash[:notice] = "カードが登録できませんでした"
      redirect_to redirect_to("/manga/#{@manga.id}")
    end

    #pay部分
    @manga = $current_manga
    price = @manga.price*@manga.volume
    # 保存したカードのカスタマーidで払う。
    logger.debug("カスタマーid")
    logger.debug card.customer_id
    if card.customer_id.present?
      charge = Payjp::Charge.create(
        amount: price,
        customer: card.customer_id,
        currency: 'jpy'
      )
    else
      flash[:notice] = "カードが登録されていません。"
      redirect_to("/manga/#{@manga.id}")
    end
    @give = Give.new(
      user_id: @current_user.id,
      manga_id: @manga.id,
      price: @manga.price,
      done: 0,
    )
    # pay書き込み部分
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
        @selectoffer = @notyetoffers.sample #sampleでランダムに選んでいる
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
