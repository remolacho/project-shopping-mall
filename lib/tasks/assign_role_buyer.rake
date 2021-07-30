# frozen_string_literal: true
# rake assign_role_buyer:run
namespace :assign_role_buyer do
  desc 'TODO'
  task run: :environment do
    puts '############################ Se inicia asignacion ################################'

    users = User.where(provider: ["google", "facebook"])

    total = users.map { |user|
      next 0 if user.roles.present?

      user.add_role(:buyer)

      1
    }.sum

    puts "Total asigmados: #{total}"
    puts '############################ Fin asignacion ################################3'
  end
end
