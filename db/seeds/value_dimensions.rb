# Value Dimensions Seed Data
# 8 core political value dimensions

puts "  Creating value dimensions..."

dimensions = [
  {
    key: 'liberty_authority',
    name: 'Individual Liberty vs Collective Authority',
    description: 'The balance between personal freedom and collective governance',
    left_pole: 'Individual Liberty',
    right_pole: 'Collective Authority',
    left_description: 'Prioritizes personal autonomy, minimal government intervention, and individual rights',
    right_description: 'Prioritizes collective decision-making, strong institutions, and social order',
    position: 1
  },
  {
    key: 'economic_equality',
    name: 'Economic Equality vs Free Markets',
    description: 'The role of government in economic redistribution and market regulation',
    left_pole: 'Economic Equality',
    right_pole: 'Free Markets',
    left_description: 'Supports wealth redistribution, strong safety nets, and economic regulation',
    right_description: 'Supports minimal regulation, private enterprise, and market-driven outcomes',
    position: 2
  },
  {
    key: 'tradition_progress',
    name: 'Tradition vs Progress',
    description: 'The value placed on preserving traditions versus embracing change',
    left_pole: 'Tradition',
    right_pole: 'Progress',
    left_description: 'Values established customs, cultural continuity, and proven institutions',
    right_description: 'Values innovation, social change, and challenging established norms',
    position: 3
  },
  {
    key: 'nationalism_globalism',
    name: 'Nationalism vs Globalism',
    description: 'The priority given to national interests versus international cooperation',
    left_pole: 'Nationalism',
    right_pole: 'Globalism',
    left_description: 'Prioritizes national sovereignty, borders, and domestic interests',
    right_description: 'Prioritizes international cooperation, open borders, and global governance',
    position: 4
  },
  {
    key: 'security_privacy',
    name: 'Security vs Privacy',
    description: 'The tradeoff between collective security and individual privacy',
    left_pole: 'Security',
    right_pole: 'Privacy',
    left_description: 'Prioritizes public safety, surveillance, and preventive measures',
    right_description: 'Prioritizes personal privacy, civil liberties, and limited surveillance',
    position: 5
  },
  {
    key: 'meritocracy_equity',
    name: 'Meritocracy vs Equity',
    description: 'The approach to addressing social and economic disparities',
    left_pole: 'Meritocracy',
    right_pole: 'Equity',
    left_description: 'Rewards based on individual achievement and competition',
    right_description: 'Adjusts for systemic barriers to ensure equal outcomes',
    position: 6
  },
  {
    key: 'environment_growth',
    name: 'Environmental Protection vs Economic Growth',
    description: 'The priority given to environmental conservation versus economic development',
    left_pole: 'Environmental Protection',
    right_pole: 'Economic Growth',
    left_description: 'Prioritizes sustainability, conservation, and climate action',
    right_description: 'Prioritizes economic development, jobs, and industrial growth',
    position: 7
  },
  {
    key: 'direct_representative',
    name: 'Direct Democracy vs Representative Democracy',
    description: 'The preferred mechanism for democratic decision-making',
    left_pole: 'Direct Democracy',
    right_pole: 'Representative Democracy',
    left_description: 'Citizens vote directly on policies and laws',
    right_description: 'Elected representatives make decisions on behalf of citizens',
    position: 8
  }
]

dimensions.each do |dim_data|
  dimension = ValueDimension.find_or_initialize_by(key: dim_data[:key])
  dimension.update!(dim_data)
  puts "    ✓ #{dimension.name}"
end

puts "  ✅ Created #{ValueDimension.count} value dimensions"

