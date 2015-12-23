module SessionsHelper
  def admin?
    session[:password_digest] == admin_digest
  end

  def authorize
    unless admin?
      flash[:error] = 'Unauthorized access'
      redirect_to root_url
    end
  end

  def admin_digest
    if Rails.env.development? || Rails.env.test?
      Digest::SHA1.hexdigest('qwerty')
    else
      ENV['PASS_DIGEST']
    end
  end
end
