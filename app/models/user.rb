# == Schema Information
#
# Table name: users
#
#  id              :integer          not null, primary key
#  name            :string(255)
#  email           :string(255)
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  password_digest :string(255)
#  remember_token  :string(255)
#  admin           :boolean          default(FALSE)
#  superuser       :boolean          default(FALSE)
#

class User < ActiveRecord::Base
  attr_accessible :email, :name, :password, :password_confirmation
  has_secure_password
  
  has_many :country_admins, dependent: :destroy
  
  before_save { self.email.downcase! }
  before_save :create_remember_token
  
  validates :name, presence: true, length: { maximum: 50 }
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email, presence: true, format: { with: VALID_EMAIL_REGEX },
  									uniqueness: { case_sensitive: false }
  validates :password, presence: true, length: { minimum: 6 }
  validates :password_confirmation, presence: true
  validates :admin, :inclusion => { :in => [true, false] }
  validates :superuser, :inclusion => { :in => [true, false] }
  
  default_scope order: 'users.name ASC' 
    
  def administrator?(country)
    @country = Country.find_by_country(country)
    @records = CountryAdmin.where("country_id = ? and user_id = ?", @country, self).count
    @records > 0
  end
    
  private

    def create_remember_token
      self.remember_token = SecureRandom.urlsafe_base64
    end
end
