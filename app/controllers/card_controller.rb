class CardController < ApplicationController

  before_action :authenticate_user, {only:[:new,:create]}

  require "payjp"

  def new
    card = Card.where(user_id: @current_user.id)
    # redirect_to "/card/show" if card.exists?
    # logger.debug("ログは動いています")
    # logger.debug(ENV['PAYJP_SECRET_KEY'])
    # logger.debug("上にkeyが出ます")
  end

  def create
    # pay.jpのjsから送られてきたparamsでcustomerオブジェクトを作る。
    # logger.debug("ログは動いています")
    # logger.debug(ENV["PAYJP_SECRET_KEY"])
    # logger.debug("上にkeyが出ます")
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
    if card.save
      redirect_to "/user/page"
    else
      redirect_to "/card/new"
    end
  end

  def show

    Payjp.api_key = ENV["PAYJP_SECRET_KEY"] # PAY.JPに秘密鍵を使ってアクセス
    # card = Card.find_by(user_id: @current_user.id) # cardsテーブルからユーザーのカード情報を取得
    # 今のユーザのカード情報を全て取得
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
    @card.push(customer_each.cards.first)# cards.firstで登録した最初のカード情報を取得
      # logger.debug("@cardはこれ")
      # logger.debug @card.inspect
    end
    # card.each do |card_each|
    #   customer = Payjp::Customer.retrieve(card_each.customer_id) # 顧客idを元に、顧客情報を取得
    #   logger.debug("cunstomerはこれ")
    #   logger.debug customer.inspect
    #   @card = customer.cards.first # cards.firstで登録した最初のカード情報を取得
    #   logger.debug("@cardはこれ")
    #   logger.debug @card.inspect
    # end

  end

  #
  # def pay
  #   Payjp.api_key = ENV["PAYJP_SECRET_KEY"]
  #   if params['payjp_token'].blank?
  #     redirect_to action: "new"
  #   else
  #     customer = Payjp::Customer.create(
  #     description: '登録テスト',
  #     email: current_user.email,
  #     card: params['payjp_token'],
  #     metadata: {user_id: current_user.id}
  #     )
  #     @card = Card.new(
  #       user_id: current_user.id,
  #       customer_id: customer.id,
  #       card_id: customer.default_card
  #     )
  #     if @card.save
  #       redirect_to action: "show"
  #     else
  #       redirect_to action: "pay"
  #     end
  #   end
  # end
  #
  # def show
  #   card = Card.find_by(user_id: current_user.id)
  #   if card.blank?
  #     redirect_to action: "new"
  #   else
  #     Payjp.api_key = ENV["PAYJP_SECRET_KEY"]
  #     customer = Payjp::Customer.retrieve(card.customer_id)
  #     @default_card_information = customer.cards.retrieve(card.card_id)
  #   end
  # end
  #
  # def delete
  #   card = Card.find_by(user_id: current_user.id)
  #   if card.blank?
  #   else
  #     Payjp.api_key = ENV["PAYJP_SECRET_KEY"]
  #     customer = Payjp::Customer.retrieve(card.customer_id)
  #     customer.delete
  #     card.delete
  #   end
  #   redirect_to action: "new"
  # end

  # def pay #payjpとCardのデータベース作成を実施します。
  #   Payjp.api_key = ENV["PAYJP_PRIVATE_KEY"]
  #   if params['payjp-token'].blank?
  #     redirect_to action: "new"
  #   else
  #     customer = Payjp::Customer.create(
  #     description: '登録テスト', #なくてもOK
  #     email: @current_user.email, #なくてもOK
  #     card: params['payjp-token'],
  #     metadata: {user_id: @current_user.id}
  #     ) #念の為metadataにuser_idを入れましたがなくてもOK
  #     @card = Card.new(user_id: @current_user.id, customer_id: customer.id, card_id: customer.default_card)
  #     if @card.save
  #       redirect_to action: "show"
  #     else
  #       redirect_to action: "pay"
  #     end
  #   end
  # end

  # def delete #PayjpとCardデータベースを削除します
  #   card = Card.where(user_id: @current_user.id).first
  #   if card.blank?
  #   else
  #     Payjp.api_key = ENV["PAYJP_PRIVATE_KEY"]
  #     customer = Payjp::Customer.retrieve(card.customer_id)
  #     customer.delete
  #     card.delete
  #   end
  #     redirect_to action: "new"
  # end
  #
  # def show #Cardのデータpayjpに送り情報を取り出します
  #   card = Card.where(user_id: @current_user.id).first
  #   if card.blank?
  #     # flash[:notice] = "カードが登録されていません"
  #     # redirect_to action: "new"
  #   else
  #     Payjp.api_key = ENV["PAYJP_PRIVATE_KEY"]
  #     customer = Payjp::Customer.retrieve(card.customer_id)
  #     @default_card_information = customer.cards.retrieve(card.card_id)
  #   end
  # end
end
