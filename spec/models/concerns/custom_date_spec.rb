shared_examples_for "date" do
  let(:date) { FactoryGirl.build(:date) }
  subject { date }
  it { should be_valid }
  
  it { should belong_to :person }
  it { should validate_presence_of :person }
  it { should validate_presence_of :year }
  it { should validate_numericality_of(:year).is_greater_than_or_equal_to(1000) }
  
  context "when valid" do
    [:date, :just_year, :without_day].each do |valid|
      it "should pass validations" do
        date = FactoryGirl.build(valid)
        expect(date).to be_valid
      end
    end
  end
  
  context "when invalid" do
    invalid_dates = [:invalid_date, :future_date, :future_year, :future_month,
                     :invalid_year, :invalid_month, :without_month,
                     :very_invalid_date]
    invalid_dates.each do |invalid|
      it "shouldn't pass validations" do
        date = FactoryGirl.build(invalid)
        expect(date).not_to be_valid
      end
    end
  end
  
  it "should be properly stringified" do
    expect(date.to_s).to eq '2012.02.29'
    expect(factory_to_s(:just_year)).to eq '1000'
    expect(factory_to_s(:without_day)).to eq 'grudzień 1000'
  end
  
  it "can be compared" do
    equal_pairs = [[[2013, 7], [2013, 7, 13]], [[1902], [1902, 4, 6]], 
                   [[1834, 2, 3], [1834, 2, 3]]]
                   
    earlier_later_pairs = [[[1900, 1, 23], [1900, 2]], [[1911, 6], [1912]],
                           [[1234, 3, 3], [1234, 3, 4]], [[1456], [1457, 7]]]
                           
    equal_pairs.each do |eq1, eq2|
      expect(birth_date(*eq1) <=> birth_date(*eq2)).to be_zero
    end
    
    earlier_later_pairs.each do |eq1, eq2|
      expect(birth_date(*eq1) <=> birth_date(*eq2)).to eq(-1)
    end
  end
end
