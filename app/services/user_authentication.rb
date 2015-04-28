class UserAuthentication
  include Singleton

  def authenticate(user, password)
    user.password == password
  end
end