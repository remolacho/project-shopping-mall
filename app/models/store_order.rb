# == Schema Information
#
# Table name: store_orders
#
#  id               :bigint           not null, primary key
#  adjustment_total :integer
#  clean_total      :integer
#  delivery_state   :string
#  global_tax_total :integer
#  mail             :string
#  order_number     :string
#  payment_state    :string
#  payment_total    :integer
#  phone            :string
#  shipment_total   :integer
#  special_comments :string
#  state            :string
#  total            :integer
#  user_name        :string
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  order_id         :integer
#  store_id         :integer
#
# Indexes
#
#  index_store_orders_on_order_id  (order_id)
#  index_store_orders_on_store_id  (store_id)
#
class StoreOrder < ApplicationRecord
  belongs_to :order
  belongs_to :store
  has_one :user, through: :order
  has_many :order_adjustments, as: :adjustable
  has_many :order_items
end
# Order.create!(user_id: 1, completed_at: Time.zone.now.to_datetime, state: 'Pagado', payment_total: 24000, shipment_total: 1000, adjustment_total: 2000, delivery_state: 'Por entregar', payment_state: 'Aprobado')
# StoreOrder.create!(store_id: 1, order_id: 5, mail: 'leonardo.barroeta@etiner.cl', order_number: '1234', payment_total: 24000, phone: '0979258160', special_comments: 'Comentarios', state: 'State', user_name: 'lbarroeta', payment_state: 'Aprobado', delivery_state: 'Por entregar', global_tax_total: 1000, clean_total: 2000, adjustment_total: 1000, shipment_total: 2500, total: 3000)
# OrderItem.create! product_variant_id: 1800, store_order_id: 1, store_id: 1, item_qty: 1, unit_value: 100