require 'rails_helper'

RSpec.describe Quarter, type: :model do
  let(:quarter) { build(:quarter) }
  subject { quarter }
  it { should be_valid }

  it { should have_many(:graves).dependent(:destroy) }

  it { should validate_presence_of :name }
  it { should validate_uniqueness_of :name }
  it { should validate_presence_of :short_name }
  it { should validate_uniqueness_of :short_name }

  it { should respond_to_methods [:name, :short_name] }
  its(:class) { should respond_to :create_from_short_name! }

  describe '.create_from_short_name!' do
    before { Quarter.delete_all }

    it 'should create quarter' do
      Quarter.create_from_short_name!('k3')
      expect(Quarter.find_by(name: 'Kwatera 3')).not_to be_nil
    end

    it 'should raise exception when cannot create' do
      create(:quarter, short_name: 'p3')
      expect { Quarter.create_from_short_name!('p3') }.to raise_exception
    end
  end

  describe '.sort_by_name' do
    it 'should sort quarters right' do
      names = ['zzz', 'Kwatera 14', 'Pas 2', 'Kwatera 3']
      quarters = names.map { |name| build(:quarter, name: name) }
      sorted_names = Quarter.sort_by_name(quarters).map(&:name)
      expect(sorted_names).to eq ['Kwatera 3', 'Kwatera 14', 'Pas 2', 'zzz']
    end
  end
end
