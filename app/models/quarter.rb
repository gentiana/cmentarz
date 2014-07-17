class Quarter < ActiveRecord::Base
  has_many :graves, dependent: :destroy
  validates :name, :short_name, presence: true, uniqueness: true
  
  def self.sort_by_name(array)
    # it should  be sorted like this
    # ["Kwatera 3", "Kwatera 14", "Pas 2"]
    array.sort do |a, b|
      # compare each word
      splited_pairs = a.name.split.zip(b.name.split)
      # find first different pair
      part_a, part_b = splited_pairs.drop_while { |aa, bb| aa == bb }.first
      if part_a =~ /\A\d+\z/ && part_b =~ /\A\d+\z/    # both are numbers
        part_a.to_i <=> part_b.to_i        # compare numeric values
      else
        part_a.to_s <=> part_b.to_s        # compare alphabetically
      end
    end
  end
  
  def self.create_from_short_name!(sn)
    name = if sn =~ /\Ak(\d+)\z/
      "Kwatera #{$+}"
    elsif sn =~ /\Ap(\d+)\z/
      "Pas #{$+}"
    end
    Quarter.create!(name: name, short_name: sn)
  end
end
