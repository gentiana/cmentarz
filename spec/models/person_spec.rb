require 'rails_helper'

RSpec.describe Person, :type => :model do
  it { should belong_to :grave }   # forever
  
  let(:person) { FactoryGirl.build(:person) }
  subject { person }
  it { should be_valid }
  
  it { should validate_presence_of :grave }
  it { should have_one(:birth_date).dependent(:destroy) }
  it { should have_one(:death_date).dependent(:destroy) }
  
  it_behaves_like "data state"
  
  describe "interface" do
    fields = [:first_name, :last_name, :family_name, :lived, :description,
              :notes, :data_state, :raw_record]
    associations = [:grave, :birth_date, :death_date]
    # enum = [:auto?, :checked?, :parish_books?, :user_nonchecked?]
    other_methods = [:full_name]
    
    it { should respond_to_methods(fields, associations, other_methods) }
  end
  
  context "full name" do
    its(:full_name) { should eq "Alicja Grzybowska (Piwowarczyk)"}
    specify "is correct without family name" do
      person.family_name = nil
      expect(person.full_name).to eq "Alicja Grzybowska"
      person.family_name = '    ' 
      expect(person.full_name).to eq "Alicja Grzybowska"
    end
  end
  
  specify "can't live negative number of years" do
    person.lived = -5
    expect(person).not_to be_valid
    person.lived = 0
    expect(person).to be_valid
  end
  
  specify "must be born before dies" do
    person.birth_date = FactoryGirl.build(:date)
    person.death_date = FactoryGirl.build(:death_date)
    expect(person).not_to be_valid
  end
end
