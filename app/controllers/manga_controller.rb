class MangaController < ApplicationController

  before_action :authenticate_user, {only:[:car_pay,:create_pay,:offer]}

  def top
  end

  def index

    @mangas = Manga.all
  end

  def search
    redirect_to "/" if params[:keyword] == ""

    @mangas = []
    split_keyword = params[:keyword].split(/[[:blank:]]+/)

    split_keyword.each do |keyword|  # 分割したキーワードごとに検索
      next if keyword == ""
      @mangas += Manga.where('name LIKE(?)', "%#{keyword}%") # 部分一致で検索
    end
  end

  def page
    if Manga.find_by(id:params[:id])
      @manga = Manga.find_by(id:params[:id])
      $current_manga = @manga
    else
      redirect_to("/")
    end
    if @current_user != nil
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
    # logger.debug("カスタマーid")
    # logger.debug params[:customer_id]
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
    # 取引データ書き込み
    @give = Give.new(
      user_id: @current_user.id,
      manga_id: @manga.id,
      price: @manga.price,
      volume:@manga.volume,
      amount:@manga.price*@manga.volume,
      done: 0,
    )
    if @give.save
      @notyetoffers = Offer.where(manga_id: @manga.id).where(done: 0)
      # まだオファーがなかった場合
      if @notyetoffers == []
        flash[:notice] = "支払いが完了しました"
        redirect_to("/manga/#{@manga.id}")
      # すでにオファーがあった場合
      else
        @selectoffer = @notyetoffers.sample #sampleでランダムに選んでいる
        @user = @current_user

        @selectoffer.given_by = @give.user_id
        @selectoffer.done = 1
        @selectoffer.give_id = @give.id
        @selectoffer.save

        @give.done = 1
        @give.target_id = @selectoffer.user_id
        @give.offer_id = @selectoffer.id
          # logger.debug("give.amount")
          # logger.debug @give.amount
          # logger.debug("give.volume")
          # logger.debug @give.volume
        @user.total_amount_paid += @give.amount
        @user.total_books_given += @give.volume
          # logger.debug("ユーザのトータル支払い")
          # logger.debug @user.total_amount_paid
          # logger.debug("ユーザのトータル奢り数")
          # logger.debug @user.total_books_given
        @give.save
        @user.save

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
      volume:@manga.volume,
      amount:@manga.price*@manga.volume,
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
        @user = @current_user

        @selectoffer.given_by = @give.user_id
        @selectoffer.done = 1
        @selectoffer.give_id = @give.id
        @selectoffer.save

        @give.done = 1
        @give.target_id = @selectoffer.user_id
        @give.offer_id = @selectoffer.id
        @user.total_amount_paid = @give.amount
        @user.total_books_given = @give.volume
        @give.save
        @user.save
        target = User.find_by(id:@selectoffer.user_id)
        flash[:notice] = "#{target.name}さんに奢りました"
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
        target = User.find_by(id:@selectoffer.user_id)
        flash[:notice] = "#{target.name}さんに奢りました"
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
        # 残りのギブがない場合
        if @notyetgives == []
          flash[:notice] = "オファー完了しました。"
          redirect_to("/manga/#{@manga.id}")
        # ギブが残っている場合
        else
          @selectgive = @notyetgives.first
          @user = User.find_by(id:@selectgive.user_id)

          @selectgive.target_id = @offer.user_id
          @selectgive.done = 1
          @selectgive.offer_id = @offer.id
            # logger.debug("give.amount")
            # logger.debug @selectgive.amount
            # logger.debug("give.volume")
            # logger.debug @selectgive.volume
          @user.total_amount_paid += @selectgive.amount
          @user.total_books_given += @selectgive.volume
            # logger.debug("ユーザのトータル支払い")
            # logger.debug @user.total_amount_paid
            # logger.debug("ユーザのトータル奢り数")
            # logger.debug @user.total_books_given
          @selectgive.save
          @user.save

          @offer.done = 1
          @offer.given_by = @selectgive.user_id
          @offer.give_id = @selectgive.id
          @offer.save

          flash[:notice] = "#{User.find_by(id:@selectgive.user_id).name}さんから頂きました"
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
    @gives = Give.where(done:1).where(sent:nil)
    @mangas = Manga.all
    @users = User.all
  end

  def sent
    @give = Give.find_by(id:params[:id])
    @give.sent = 1
    @give.save

    @offer = Offer.find_by(give_id:@give.id)
    if @offer
      @offer.sent = 1
      @offer.save
    end

    flash[:notice] = "#{@give.id}番取引発送しました。"
    redirect_to("/manga/deal")
  end

  def receive
    @offer = Offer.find_by(id:params[:id])
    @offer.received = 1
    @offer.save

    @give = Give.find_by(id:@offer.give_id)
    if @give
      @give.received = 1
      @give.save
    end
    flash[:notice] = "取引完了しました。"
    redirect_to("/user/page")
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
      volume: params[:volume],
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
