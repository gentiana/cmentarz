require 'rails_helper'

RSpec.describe Quarter, :type => :model do
  it { should have_many :graves }
  it { should validate_presence_of :name }
end
