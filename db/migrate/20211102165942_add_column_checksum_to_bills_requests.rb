class AddColumnChecksumToBillsRequests < ActiveRecord::Migration[6.0]
  def change
    add_column :bills_requests, :checksum, :string
  end
end
