class Users::AddressController < ApplicationController

  def create
    current_user.create_address!(address_params)
    render json: {success: true, address: Orders::AddressSerializer.new(current_user.address)}, status: 200
  end

  def update
    current_user.address.update!(address_params)
    render json: {success: true, address: Orders::AddressSerializer.new(current_user.address)}, status: 200
  end

  private

  def address_params
    params.require(:address).permit(:phone, :street, :street_number, :comment)
  end
end