# == Schema Information
#
# Table name: users
#
#  id                     :bigint           not null, primary key
#  birthdate              :date
#  complementary_info     :json
#  create_by              :integer
#  email                  :string           default(""), not null
#  encrypted_password     :string           default(""), not null
#  gender                 :string
#  jti                    :string
#  lastname               :string
#  name                   :string
#  remember_created_at    :datetime
#  reset_password_sent_at :datetime
#  reset_password_token   :string
#  rut                    :string
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#
# Indexes
#
#  index_users_on_email                 (email) UNIQUE
#  index_users_on_reset_password_token  (reset_password_token) UNIQUE
#
class User < ApplicationRecord

  rolify

  has_one_attached :image

  has_many :companies
  has_many :stores, through: :companies
  has_many :orders
  has_many :store_orders, through: :orders
  has_one :address

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :jwt_authenticatable, jwt_revocation_strategy: JwtBlacklist

  MALE = 'male'.freeze
  FEMALE = 'female'.freeze
  OTHER = 'other'.freeze
  
  validates_inclusion_of :gender, in: [MALE, FEMALE, OTHER], allow_blank: true

  validates_presence_of :password, on: :create
  validates_presence_of :name, :email

  def full_name
    "#{name.titleize} #{lastname.titleize}"
  end

  def jwt_payload
    { id: id, email: email, full_name: full_name, roles: roles.map(&:name) }
  end

  def on_jwt_dispatch(_token, _payload)
    JwtBlacklist.where('exp < ?', Date.today).destroy_all
  end
end
