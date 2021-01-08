class ChangeDataNameToStore < ActiveRecord::Migration[6.0]
  def change
    Store.all.each do |store|
      store.name = Faker::Book.title
      store.save
      puts store.name
    end
  end
end
