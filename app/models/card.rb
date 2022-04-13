class Card < ApplicationRecord

  def self.debug
    logger.debug("ログは動いています")
    logger.debug(ENV["PAYJP_SECRET_KEY"])
    logger.debug("上にkeyが出ます")
  end

end
