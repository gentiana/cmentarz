class Quarter < ActiveRecord::Base
  has_many :graves
  validates :name, :short_name, presence: true, uniqueness: true
  
  def self.create_from_short_name!(sn)
    name = if sn =~ /\Ak(\d+)\z/
      "Kwatera #{$+}"
    elsif sn =~ /\Ap(\d+)\z/
      "Pas #{$+}"
    end
    Quarter.create!(name: name, short_name: sn)
  end
end
