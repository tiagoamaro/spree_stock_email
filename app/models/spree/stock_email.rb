class Spree::StockEmail < ActiveRecord::Base

  belongs_to :variant

  validates :variant, presence: true
  validates :email, presence: true, email: true
  validates_uniqueness_of :email, conditions: -> { where(sent_at: nil) }, scope: :variant_id, message: Spree.t('stock_email.messages.already_registered')

  def self.not_sent(variant)
    where(sent_at: nil, variant_id: variant.id)
  end

  def self.notify(variant)
    self.not_sent(variant).each { |e| e.notify }
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
