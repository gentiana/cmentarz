require 'rails_helper'

RSpec.describe Person, :type => :model do
  it { should belong_to :grave }
  it { should have_one(:birth_date).dependent(:destroy) }
  it { should have_one(:death_date).dependent(:destroy) }
end
