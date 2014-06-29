require 'rails_helper'

RSpec.describe Grave, :type => :model do
  it { should have_many :people }
  it { should belong_to :quarter }
  it { should validate_presence_of :number }
end
