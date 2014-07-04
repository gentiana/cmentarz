require 'rails_helper'

RSpec.describe Grave, :type => :model do
  let(:grave) { build(:grave) }
  subject { grave }
  it { should be_valid }
  
  it { should have_many :people }
  it { should belong_to :quarter }
  it { should validate_presence_of :number }
  
  describe "interface" do
    fields = [:number, :grave_type, :description, :family_name, :notes,
              :data_state]
    associations = [:quarter, :people]
    enum = [:single?, :family?]
    other = [:set_grave_type!]
    
    it { should respond_to_methods(fields, associations, enum, other) }
  end
  
  it_behaves_like "data state"
  
  specify "quarter and number combinaiton should be unique" do
    grave.save
    grave2 = create(:grave)
    expect(grave2).to be_valid
    grave2.quarter = grave.quarter
    expect(grave2).not_to be_valid
  end
  
  context "set_grave_type!" do
    it "should set type to single when without people" do
      grave.family!
      grave.set_grave_type!
      expect(grave).to be_single
    end
  end
end
