require 'bcrypt'

class User
  include Mongoid::Document
  include BCrypt

  field :username, type: String
  field :password_hashed, type: String
  has_many :documents

  def password
    if self.password_hashed == nil
      return nil
    end
    @password = Password.new(self.password_hashed)
  end

  def password=(new_pass)
    @password = Password.create(new_pass)
    self.password_hashed = @password
  end
end
