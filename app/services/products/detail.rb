class Products::Detail

  attr_accessor :user, :product

  def initialize(user:, product:)
    @user = user
    @product = product
  end

  def perform
    ::Products::DetailSerializer.new(product)
  end
end
