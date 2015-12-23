require 'rails_helper'

RSpec.describe 'Authorization', type: :request do
  subject { page }

  describe 'login' do
    before { visit login_path }
    let(:login) { t('sessions.new.login') }
    let(:logout) { t('menu.logout') }

    it { should have_content login }

    context 'with valid password' do
      before do
        fill_in :password, with: 'qwerty'
        click_button login
      end

      it { should have_link logout }

      context 'followed by logout' do
        before { click_link logout }
        it { should_not have_link logout }
      end
    end

    context 'with invalid password' do
      before do
        fill_in :password, with: 'admin1'
        click_button login
      end

      it { should_not have_link logout }
    end
  end

  context 'as non-admin' do
    let(:grave) { create(:grave) }
    let(:quarter) { create(:quarter) }
    let(:person) { create(:person) }

    describe 'when visiting forbidden pages' do
      after do
        expect(current_path).to eq root_path
        should have_content 'Unauthorized access'
      end

      context 'in the Graves controller' do
        specify { visit new_grave_path }
        specify { visit edit_grave_path(grave) }
      end

      context 'in the Quarters controller' do
        specify { visit new_quarter_path }
        specify { visit edit_quarter_path(quarter) }
      end

      context 'in the People controller' do
        specify { visit new_person_path }
        specify { visit edit_person_path(person) }
      end
    end

    describe 'when sending HTTP request' do
      after { expect_redirect }

      context 'in the Graves controller' do
        specify { post graves_path }
        specify { patch grave_path(grave) }
        specify { delete grave_path(grave) }
      end

      context 'in the Quarters controller' do
        specify { post quarters_path }
        specify { patch quarter_path(quarter) }
        specify { delete quarter_path(quarter) }
      end

      context 'in the People controller' do
        specify { post people_path }
        specify { patch person_path(person) }
        specify { delete person_path(person) }
      end
    end
  end
end
