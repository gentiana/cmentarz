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
  
  describe "show" do
    let(:grave) { create(:grave) }
    before { visit grave_path(grave) }
    
    it "should have the right content" do
      contents = [grave.name, grave.number, grave.description]
      admin_contents = [grave.family_name, grave.notes]
      (contents + admin_contents).each do |content|
        expect(page).to have_content content
      end
    end
    
    it { should have_link grave.quarter.name }
    it { should have_link t('helpers.links.edit') }
    it { should have_link t('helpers.links.destroy') }
    
    context "grave with associated people" do
      let!(:p1) { create(:person, grave: grave) }
      let!(:p2) { create(:person, grave: grave, first_name: 'Hilda') }
      before {visit grave_path(grave) }
      
      it "should list associated people" do
        expect(page).to have_link p1.full_name
        expect(page).to have_link p2.full_name
      end
    end
  end
end
