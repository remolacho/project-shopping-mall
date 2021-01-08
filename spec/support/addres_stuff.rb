shared_context 'address_stuff' do

  let(:params_address){{
    address: {
      street: "Park Avenue",
      street_number: "1090",
      phone: "987654321",
      comment: "turn left and turn right",
    }
  }}

  let(:params_address_2){{
    address: {
      street: "Other Park Avenue",
      street_number: "300",
      phone: "123456789",
      comment: "turn left and turn right",
    }
  }}

  let(:create_address){
    current_user.create_address({
      street: "Park Avenue",
      street_number: "1090",
      phone: "987654321",
      comment: "turn left and turn right",
    })
  }

end