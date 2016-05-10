class Ticket < ActiveRecord::Base

  has_many :sales
  has_many :products, through: :sales
  scope :unread, -> { where(read: false) }

end
