require 'rails_helper'

RSpec.describe Grave, :type => :model do
  let(:grave) { build(:grave) }
  subject { grave }
  it { should be_valid }
  
  it { should have_many(:people).dependent(:destroy) }
  it { should belong_to :quarter }
  it { should validate_presence_of :number }
  
  describe "interface" do
    fields = [:number, :grave_type, :description, :family_name, :notes,
              :data_state]
    associations = [:quarter, :people]
    enum = [:single?, :family?]
    other = [:set_grave_type!]
    
    it { should respond_to_methods(fields, associations, enum, other) }
    its(:class) { should respond_to :quarterless, :names }
  end
  
  it_behaves_like "data state"
  
  describe "validations" do
    specify "quarter and number combinaiton should be unique" do
      grave.save
      grave2 = create(:grave, number: grave.number)
      expect(grave2).to be_valid
      grave2.quarter = grave.quarter
      expect(grave2).not_to be_valid
    end
    
    specify "number can't be negative" do
      grave.number = '-5'
      expect(grave).not_to be_valid
    end
  end
  
  describe ".names" do
    let!(:quarterless) { create(:quarterless_grave) }
    let!(:g1) { create(:grave) }
    let!(:g2) { create(:grave, quarter: g1.quarter) }
    let!(:g3) { create(:grave) }
    
    it "returns names and ids of graves in given quarter" do
      graves = [{id: g1.id, name: g1.name}, {id: g2.id, name: g2.name}]
      expect(Grave.names(g1.quarter.id)).to eq graves
    end
    
    context "when the quarter is blank" do
      it "returns names and ids of all graves without quarter" do
        quarterless_hash = {id: quarterless.id, name: quarterless.name}
        expect(Grave.names('')).to eq [quarterless_hash]
      end
    end
  end
  
  describe "#set_grave_type!" do
    it "should set type to single when without people" do
      grave.family!
      grave.set_grave_type!
      expect(grave).to be_single
    end
  end
  
  describe "#name" do
    context "when grave's number is an integer" do
      its(:name) { should eq "Grób nr #{grave.number}" }
    end
    
    context "when grave's number isn't an integer" do
      let(:name) { "Grób nieznanego żołnierza" }
      before { grave.number = name }
      its(:name) { should eq name }
    end
  end
  
  describe "comparing" do
    it "should sort graves by quarter_id and by number" do
      quarter1 = [build_grave(1, 555)]
      quarter3 = %w(6 100 qwerty asdf 777blah).map { |num| build_grave(3, num) }
      graves = quarter1 + quarter3
      expect(graves.sort.map(&:number)).to eq %w(555 777blah asdf qwerty 6 100)
    end
  end
end
