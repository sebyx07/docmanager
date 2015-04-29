require 'bcrypt'

class User
  include Mongoid::Document
  include BCrypt

  field :username, type: String
  field :password_hashed, type: String
  attr_accessor :password_temp, :password_temp_confirm

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

  def set_password
    if password_temp && password_temp_confirm && password_temp == password_temp_confirm
      password = password_temp
    else
      self.errors.add(:password, 'Invalid password')
      false
    end
  end
end
