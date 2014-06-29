module CustomDate
  extend ActiveSupport::Concern
  
  included do
    belongs_to :person
    validates :year, presence: true,
                     numericality: { greater_than_or_equal_to: 1000 }
  end
end
