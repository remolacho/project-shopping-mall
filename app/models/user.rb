# == Schema Information
#
# Table name: users
#
#  id                     :bigint           not null, primary key
#  complementary_info     :json
#  create_by              :integer
#  email                  :string           default(""), not null
#  encrypted_password     :string           default(""), not null
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
         :recoverable, :rememberable, :validatable

  def full_name
    "#{name.titleize} #{lastname.titleize}"
  end

end
