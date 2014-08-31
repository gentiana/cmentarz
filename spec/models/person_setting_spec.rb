require 'rails_helper'

RSpec.describe PersonSetting, type: :model do
  let(:factory) { PersonSettingFactory.new }
  
  describe "#initialize" do
    specify "initializing with blank date params should set them to nil" do
      setting = factory.empty_birth_params
      expect(setting.birth_params).to be_nil
      expect(setting.death_params).not_to be_nil
    end
  end
  
  describe "#update" do
    specify "delete birth date and create death date" do
      setting = factory.delete_birth_date
      result = setting.update
      expect(bool(result)).to eq true
      setting.person.reload
      expect(setting.person.birth_date).to be_nil
      expect(setting.person.death_date).not_to be_nil
    end
    
    specify "leave empty death date empty and update birth date" do
      setting = factory.update_birth_date
      result = setting.update
      expect(bool(result)).to eq true
      setting.person.reload
      expect(setting.person.birth_date).not_to be_nil
      expect(setting.person.death_date).to be_nil
    end
    
    it "detects all errors and do rollback" do
      setting = factory.everything_wrong
      previous_updated_at = setting.person.updated_at
      result = setting.update
      expect(bool(result)).to eq false
      errors = setting.person.errors
      birth_errors = setting.person.birth_date.errors
      death_errors = setting.person.death_date.errors
      expect(errors.keys).to include :lived
      expect(birth_errors.keys).to include :base
      expect(death_errors.keys).to include :base, :year
      expect(setting.person.updated_at).to eq previous_updated_at
    end
  end
end
