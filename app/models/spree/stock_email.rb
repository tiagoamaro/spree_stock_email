class Spree::StockEmail < ActiveRecord::Base

  belongs_to :product

  validates :product, presence: true
  validates :email, presence: true, email: true
  validates_uniqueness_of :email, conditions: -> { where(sent_at: nil) }, scope: :product_id, message: Spree.t('stock_email.messages.already_registered')

  def self.not_sent(product)
    where(sent_at: nil, product_id: product.id)
  end

  def self.notify(product)
    self.not_sent(product).each { |e| e.notify }
  end

  def notify
    Spree::StockEmailsMailer.stock_email(self).deliver
    mark_as_sent
  end

  private

  def mark_as_sent
    update_attribute :sent_at, Time.zone.now
  end
end
