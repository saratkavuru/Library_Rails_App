class Room < ApplicationRecord
  belongs_to :library
  has_many :booking , :dependent => :delete_all
  # has_one :library
  # attr_accessible :room_number, :library_id
  validates :room_number, :presence => true
  validates :room_number, :uniqueness => {:scope => :library}
  validates :capacity, :presence => true
  validates :library, :presence => true
  enum capacity: { "Small - 4 Chairs "=>4, "Medium - 6 Chairs" => 6, "Large - 12 Chairs"=>12 }

  def to_s
    return self.library.name + ", Room " + self.room_number.to_s
  end
# to check if room is available
  def available?(start_time = DateTime.now)
  	unless (self.booking.where('start_time between ? and ?', (start_time.to_datetime - 2.hours).to_datetime, (start_time.to_datetime + 2.hours).to_datetime).length > 0) 
  		return true
  	else 
  		return false
  	end
  end
end
