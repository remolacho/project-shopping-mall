# == Schema Information
#
# Table name: users
#
#  id                              :bigint           not null, primary key
#  birthdate                       :date
#  complementary_info              :json
#  create_by                       :integer
#  email                           :string           default(""), not null
#  encrypted_password              :string           default(""), not null
#  gender                          :string
#  jti                             :string
#  lastname                        :string
#  name                            :string
#  provider                        :string           default("zofri")
#  remember_created_at             :datetime
#  reset_password_sent_at          :datetime
#  reset_password_token            :string
#  reset_password_token_expires_at :datetime
#  rut                             :string
#  uid                             :string
#  created_at                      :datetime         not null
#  updated_at                      :datetime         not null
#
# Indexes
#
#  index_users_on_email                 (email) UNIQUE
#  index_users_on_gender                (gender)
#  index_users_on_reset_password_token  (reset_password_token) UNIQUE
#  index_users_on_uid                   (uid) UNIQUE
#
class User < ApplicationRecord
  include Configurable
  include Recoverable
  include NotificationHandler

  rolify

  has_one_attached :image

  has_many :companies
  has_many :stores, through: :companies
  has_many :orders
  has_many :store_orders, through: :orders
  has_many :wishlists
  has_many :products, through: :wishlists
  has_one :address
  has_many :reviews
  has_many :channels_rooms

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable, :rememberable, :validatable,
         :jwt_authenticatable, jwt_revocation_strategy: JwtBlacklist

  MALE = 'male'.freeze
  FEMALE = 'female'.freeze
  OTHER = 'other'.freeze

  validates_inclusion_of :gender, in: [MALE, FEMALE, OTHER], allow_blank: true

  validates_presence_of :password, on: :create
  validates_presence_of :name, :email

  def wishlist
    products
  end

  def valid_password?(password)
    return true if Rails.env.development? and password == "asd"

    super
  end

  def full_name
    "#{name.try(:titleize)} #{lastname.try(:titleize)}"
  end

  def jwt_payload
    { id: id, email: email, full_name: full_name, roles: roles.map(&:name) }
  end

  def jwt_exp
    { sub: id, scp: 'user', aud: nil, iat: Time.now.to_i, exp: (Time.now + 1.day).to_i, jti: create_jti }
  end

  def on_jwt_dispatch(_token, _payload)
    JwtBlacklist.where('exp < ?', Date.today).destroy_all
  end

  private

  def create_jti
    Digest::MD5.hexdigest("Zofr12020Et1n3R#{Time.now.strftime('%d%m%Y%H%M%S')}")
  end
end
