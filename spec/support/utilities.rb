include ApplicationHelper

def factory_to_s(factory_name)
  FactoryGirl.build(factory_name).to_s
end

def birth_date(year, month=nil, day=nil)
  BirthDate.new(year: year, month: month, day: day)
end

def build_grave(quarter_id, number)
  build(:grave, quarter_id: quarter_id, number: number.to_s)
end

def t(string, options={})
  I18n.t(string, options)
end

def expect_redirect(path=root_path)
  expect(response).to redirect_to(path)
end

def sign_in(options = {})
  if options[:no_capybara]
    session[:password_digest] = Digest::SHA1.hexdigest('qwerty')
  else
    visit login_path
    fill_in :password, with: "qwerty"
    click_button t('sessions.new.login')
  end
end

def simple_label(field)
  t("simple_form.labels.defaults.#{field}")
end

def saop
  save_and_open_page
end
