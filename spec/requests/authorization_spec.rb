require 'rails_helper'

RSpec.describe "Authorization", :type => :request do
  subject { page }
  
  describe "login" do
    before { visit login_path }
    
    it { should have_content "Sign in" }
    
    context "with valid password" do
      before do
        fill_in "Password", with: "qwerty"
        click_button "Sign in"
      end
      
      it { should have_link "Logout" }
      
      context "followed by logout" do
        before { click_link "Logout" }
        it { should_not have_link "Logout" }
      end
    end
    
    context "with invalid password" do
      before do
        fill_in "Password", with: "admin1"
        click_button "Sign in"
      end
      
      it { should_not have_link "Logout" }
    end
  end
  
  context "as non-admin" do
    context "in the Graves controller" do
      let(:grave) { create(:grave) }
      
      describe "when visiting forbidden pages" do
        after do
          expect(current_path).to eq root_path
          should have_content "Unauthorized access"
        end
        
        it "can't visit new grave path" do
          visit new_grave_path
        end
        
        it "can't visit edit grave path" do
          visit edit_grave_path(grave)
        end
      end
      
      describe "when sending HTTP request" do
        after { expect_redirect }
        
        it "can't create grave" do
          post graves_path
        end
        
        it "can't update grave" do
          patch grave_path(grave)
        end
        
        it "can't destroy grave" do
          delete grave_path(grave)
        end
      end
    end
  end
end
