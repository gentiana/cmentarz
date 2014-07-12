require 'rails_helper'

RSpec.describe "Quarter Pages", :type => :request do
  subject { page }
  
  describe "index" do
    before { visit quarters_path }
    let(:title) { t 'quarters.index.title' }
    
    it_behaves_like "index page"
    
    it "should list quarters" do
      quarter = create(:quarter)
      visit quarters_path
      expect(page).to have_link(quarter.name, href: quarter_path(quarter))
    end
  end
  
  describe "show" do
    let(:grave) { create(:grave) }
    before { visit quarter_path(grave.quarter) }
    
    let(:path) { quarter_path(grave.quarter) }
    let(:admin_only) { [grave.quarter.short_name] }
    let(:admin_actions) { [t('helpers.links.edit'), t('helpers.links.destroy')] }
    
    it_behaves_like "with admin content"
    
    it { should have_title "#{t 'title'} | #{grave.quarter.name}" }
    it { should have_selector 'h1', text: grave.quarter.name }
    it { should have_link grave.number, href: grave_path(grave) }
  end
  
  context "as admin user" do
    before { sign_in }
    
    describe "destroy" do
      let(:quarter) { create(:quarter) }
      before { visit quarter_path(quarter) }
      
      it "should remove quarter" do
        expect { click_link t('helpers.links.destroy') }.to change(Quarter, :count).by(-1)
      end
    end
    
    describe "edit" do
      let(:quarter) { create(:quarter) }
      
      specify "page should be avalaible from show page" do
        visit quarter_path(quarter)
        click_link t('helpers.links.edit')
        expect(page).to have_title "Edytuj kwaterę / pas"
      end
      
      specify "valid updating" do
        visit edit_quarter_path(quarter)
        update_params = attributes_for(:updated_quarter)
        fill_in simple_label(:name), with: update_params[:name]
        fill_in simple_label(:short_name), with: update_params[:short_name]
        click_button "Aktualizuj kwaterę / pas"
        expect(page).to have_contents(update_params.values)
        updated = quarter.reload
        expect(updated.name).to eq update_params[:name]
        expect(updated.short_name).to eq update_params[:short_name]
      end
      
      specify "trying to set already taken name" do
        quarter2 = create(:quarter)
        visit edit_quarter_path(quarter2)
        fill_in simple_label(:name), with: quarter.name
        click_button "Aktualizuj kwaterę / pas"
        expect(page).to have_title "Edytuj kwaterę / pas"
        expect(page).to have_content "zostało już zajęte"
      end
    end
  end
end
