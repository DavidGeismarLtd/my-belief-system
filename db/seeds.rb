# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).

puts "🌱 Seeding database..."

# Load seed files
load Rails.root.join('db', 'seeds', 'value_dimensions.rb')
load Rails.root.join('db', 'seeds', 'questions.rb')
load Rails.root.join('db', 'seeds', 'country_questions.rb')
load Rails.root.join('db', 'seeds', 'actors.rb')
load Rails.root.join('db', 'seeds', 'interventions.rb')

puts "✅ Seeding complete!"
puts "   - #{ValueDimension.count} value dimensions"
puts "   - #{Question.count} questions (#{Question.universal.count} universal, #{Question.country_specific.count} country-specific)"
puts "   - #{Actor.count} actors"
puts "   - #{Intervention.count} interventions"
