namespace :data do
  desc "Migrate actor value positions from metadata to ActorValuePortrait model"
  task migrate_actor_value_positions: :environment do
    puts "Starting migration of actor value positions..."
    
    migrated_count = 0
    skipped_count = 0
    error_count = 0
    
    Actor.find_each do |actor|
      value_positions = actor.metadata['value_positions']
      
      if value_positions.blank?
        puts "  ⚠️  Skipping #{actor.name} - no value_positions in metadata"
        skipped_count += 1
        next
      end
      
      puts "  Processing #{actor.name}..."
      
      value_positions.each do |dimension_id, position|
        begin
          # Convert string keys to integers if needed
          dimension_id = dimension_id.to_i if dimension_id.is_a?(String)
          
          # Find the value dimension
          dimension = ValueDimension.find_by(id: dimension_id)
          
          unless dimension
            puts "    ⚠️  Warning: ValueDimension with ID #{dimension_id} not found"
            error_count += 1
            next
          end
          
          # Create or update the ActorValuePortrait
          portrait = ActorValuePortrait.find_or_initialize_by(
            actor: actor,
            value_dimension: dimension
          )
          
          portrait.position = position
          # Set default values for intensity and confidence for MVP
          portrait.intensity ||= 70.0
          portrait.confidence ||= 80.0
          
          if portrait.save
            puts "    ✓ Created portrait for #{dimension.name}: position=#{position}"
            migrated_count += 1
          else
            puts "    ✗ Failed to save portrait for #{dimension.name}: #{portrait.errors.full_messages.join(', ')}"
            error_count += 1
          end
        rescue StandardError => e
          puts "    ✗ Error processing dimension #{dimension_id}: #{e.message}"
          error_count += 1
        end
      end
    end
    
    puts "\n" + "=" * 60
    puts "Migration complete!"
    puts "  ✓ Migrated: #{migrated_count} portraits"
    puts "  ⚠️  Skipped: #{skipped_count} actors"
    puts "  ✗ Errors: #{error_count}"
    puts "=" * 60
  end
end

