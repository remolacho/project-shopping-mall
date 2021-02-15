shared_context 'address_stuff' do

  let(:params_address){{
    address: {
      commune_id: 1,
      street: "Park Avenue",
      street_number: "1090",
      phone: "987654321",
      comment: "turn left and turn right",
    }
  }}

  let(:params_address_2){{
    address: {
      commune_id: 2,
      street: "Other Park Avenue",
      street_number: "300",
      phone: "123456789",
      comment: "turn left and turn right",
    }
  }}

  let(:create_address){
    current_user.create_address({
      commune_id: 1,
      street: "Park Avenue",
      street_number: "1090",
      phone: "987654321",
      comment: "turn left and turn right",
    })
  }

end