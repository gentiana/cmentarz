require 'rails_helper'

RSpec.describe PersonWithAssociations, :type => :model do
  it { should respond_to :create!}
  
  context "create!" do
    
    describe "when dates of birth and death are present" do
      subject { lambda { build(:pwa).create! } }
      
      it { should change(Grave, :count).by(1) }
      it { should change(Person, :count).by(1) }
      it { should change(BirthDate, :count).by(1) }
      it { should change(DeathDate, :count).by(1) }
    end
    
    describe "when dates of birth and death aren't present" do
      subject { lambda { build(:pwa_without_dates).create! } }
      
      it { should change(Grave, :count).by(1) }
      it { should change(Person, :count).by(1) }
      it { should_not change(BirthDate, :count) }
      it { should_not change(DeathDate, :count) }
    end
    
    describe "when params are invalid" do
      it "should raise error" do
        expect { build(:pwa_invalid).create! }.to raise_error
      end
      
      describe "it shouldn't add any records" do
        subject do
          lambda do
            begin
              build(:pwa_invalid).create!
            rescue
            end
          end
        end
        
        it { should_not change(Grave, :count) }
        it { should_not change(Person, :count) }
        it { should_not change(BirthDate, :count) }
        it { should_not change(DeathDate, :count) }
      end
    end
  end
end
