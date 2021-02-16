class Users::AddressController < ApplicationController

  def create
    current_user.create_address!(address_params)
    render json: {success: true, user: UserSerializer.new(current_user)}, status: 200
  end

  def update
    current_user.address.update!(address_params)
    render json: {success: true, user: UserSerializer.new(current_user)}, status: 200
  end

  private

  def address_params
    params.require(:address).permit(:phone, :commune_id, :street, :street_number, :comment)
  end
end