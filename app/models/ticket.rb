class Ticket < ActiveRecord::Base

  has_many :sales
  has_many :products, through: :sales
  scope :unread, -> { where(read: false) }

  def self.set_unread(first = Ticket.first, last = Ticket.last)
    Ticket.where(id: [*first[:id]..last[:id]]).each do |ticket|
      ticket.update_attribute(:read, false)
    end
  end

end
