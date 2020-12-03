module ManageObjects
  extend ActiveSupport::Concern

  def category
    Category.find(params[:category_id])
  end

  def category_or_nil
    Category.find_by(id: params[:category_id])
  end

  def product
    Product.find(params[:product_id])
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
    JWT.decode(token, ENV['JWT_SECRET'], true, {algorithm: 'HS256'})
  rescue JWT::DecodeError
    nil
  end

  def order
    return Order.find(params[:order_id]) if params[:order_id].present?
    return Order.find_by(number_ticket: params[:number_ticket]) if params[:number_ticket].present?

    Order.find_by(token: params[:order_token], state: Order::ON_PURCHASE)
  end

  def product_variant
    @product_variant ||= ProductVariant.find(params[:product_variant_id])
  end

  def order_item
    @order_item ||= OrderItem.find(params[:order_item_id])
  end
end
