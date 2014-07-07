require 'rails_helper'

RSpec.describe "Grave Pages", :type => :request do
  subject { page }
  
  describe "index" do
    before { visit graves_path }
    let(:title) { t 'graves.index.title' }
    
    it { should have_title page_title(title) }
    it { should have_selector 'h1', text: title }
    
    describe "content" do
      let!(:quarter) { create(:quarter, name: 'Kwatera 5') }
      
      it "shouldn't list quarter which has no graves" do
        expect(page).not_to have_link 'Kwatera 5'
      end
      
      it "should list quarter with its graves" do
        create(:grave, quarter: quarter, number: '555')
        visit graves_path
        expect(page).to have_link 'Kwatera 5'
        expect(page).to have_link '555'
      end
    end
  end
end
