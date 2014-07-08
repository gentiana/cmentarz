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
end
