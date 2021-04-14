# frozen_string_literal: true

module ManageObjects
  extend ActiveSupport::Concern

  def category
    @category ||= Category.find_by(slug: params[:category_id]) || Category.find(params[:category_id])
  end

  def category_or_nil
    Category.find_by(id: params[:category_id])
  end

  def product
    @product ||= Product.find_by(slug: params[:product_id]) || Product.find(params[:product_id])
  end

  def with_user
    token = request.headers['Authorization']
    return unless token.present?

    attributes = decoded_token(token)
    return unless attributes.present?
    return unless attributes[0].key?('id')

    User.find_by(id: attributes[0]['id'])
  end

  private def decoded_token(token)
    token = token.split(' ')[1]
    JWT.decode(token, ENV['JWT_SECRET'], true, { algorithm: 'HS256' })
  rescue JWT::DecodeError
    nil
  end

  def order
    return Order.find(params[:order_id]) if params[:order_id].present?
    return Order.find_by(number_ticket: params[:number_ticket]) if params[:number_ticket].present?

    Order.find_by(token: params[:order_token], state: Order::ON_PURCHASE)
  end

  def order_completed
    Order.find_by!(token: params[:order_token], state: Order::IS_COMPLETED)
  end

  def order_by_token
    @order_by_token ||= Order.where(token: params[:order_token]).where.not(token: nil).first
  end

  def user_order
    current_user.orders.find_by!(token: params[:order_token])
  end

  def product_variant
    @product_variant ||= ProductVariant.find(params[:product_variant_id])
  end

  def order_item
    @order_item ||= OrderItem.find(params[:order_item_id])
  end

  def store
    @store ||= Store.find_by!(id: params[:store_id], active: true)
  end

  def group_title
    @group_title ||= GroupTitle.find_by(slug: params[:title_id]) || GroupTitle.find(params[:title_id])
  end

  def group_title_or_nil
    @group_title_or_nil ||= GroupTitle.find_by(id: params[:title_id])
  end

  def promotion
    @promotion ||= Promotion.find_by!(promo_code: params[:promo_code])
  end

  def section_allowed
    return params[:section] if %w[discount rating recents].include?(params[:section])

    raise ArgumentError, 'The section not found'
  end
end
