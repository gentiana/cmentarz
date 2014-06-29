class Person < ActiveRecord::Base
  belongs_to :grave
  has_one :birth_date, dependent: :destroy
  has_one :death_date, dependent: :destroy
end
