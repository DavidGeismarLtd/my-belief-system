puts "  Creating actors..."

# Clear existing actors
Actor.destroy_all

# ============================================================================
# UNITED STATES - PARTIES
# ============================================================================

democratic_party = Actor.create!(
  name: "Democratic Party",
  actor_type: "party",
  country: "United States",
  description: "One of the two major political parties in the United States, generally associated with progressive and liberal policies.",
  image_url: "https://upload.wikimedia.org/wikipedia/commons/thumb/0/02/DemocraticLogo.svg/200px-DemocraticLogo.svg.png",
  program_url: "https://democrats.org/where-we-stand/party-platform/",
  active: true,
  metadata: {
    founded: 1828,
    ideology: ["Social liberalism", "Progressivism"],
    headquarters: "Washington, D.C."
  }
)

republican_party = Actor.create!(
  name: "Republican Party",
  actor_type: "party",
  country: "United States",
  description: "One of the two major political parties in the United States, generally associated with conservative policies.",
  image_url: "https://upload.wikimedia.org/wikipedia/commons/thumb/9/9b/Republicanlogo.svg/200px-Republicanlogo.svg.png",
  program_url: "https://www.gop.com/platform/",
  active: true,
  metadata: {
    founded: 1854,
    ideology: ["Conservatism", "Economic liberalism"],
    headquarters: "Washington, D.C."
  }
)

# ============================================================================
# UNITED STATES - PERSONALITIES
# ============================================================================

joe_biden = Actor.create!(
  name: "Joe Biden",
  actor_type: "personality",
  country: "United States",
  role: "President of the United States",
  party_affiliation: "Democratic Party",
  description: "46th President of the United States, serving since January 2021. Former Vice President under Barack Obama.",
  image_url: "https://upload.wikimedia.org/wikipedia/commons/thumb/6/68/Joe_Biden_presidential_portrait.jpg/200px-Joe_Biden_presidential_portrait.jpg",
  active: true,
  metadata: {
    birth_year: 1942,
    position: "President",
    term_start: "2021-01-20"
  }
)

donald_trump = Actor.create!(
  name: "Donald Trump",
  actor_type: "personality",
  country: "United States",
  role: "Former President",
  party_affiliation: "Republican Party",
  description: "45th President of the United States (2017-2021). Businessman and political figure.",
  image_url: "https://upload.wikimedia.org/wikipedia/commons/thumb/5/56/Donald_Trump_official_portrait.jpg/200px-Donald_Trump_official_portrait.jpg",
  active: true,
  metadata: {
    birth_year: 1946,
    position: "Former President",
    term_start: "2017-01-20",
    term_end: "2021-01-20"
  }
)

kamala_harris = Actor.create!(
  name: "Kamala Harris",
  actor_type: "personality",
  country: "United States",
  role: "Vice President of the United States",
  party_affiliation: "Democratic Party",
  description: "49th Vice President of the United States, serving since January 2021. First female, first Black, and first South Asian Vice President.",
  image_url: "https://upload.wikimedia.org/wikipedia/commons/thumb/4/41/Kamala_Harris_Vice_Presidential_Portrait.jpg/200px-Kamala_Harris_Vice_Presidential_Portrait.jpg",
  active: true,
  metadata: {
    birth_year: 1964,
    position: "Vice President",
    term_start: "2021-01-20"
  }
)

bernie_sanders = Actor.create!(
  name: "Bernie Sanders",
  actor_type: "personality",
  country: "United States",
  role: "U.S. Senator from Vermont",
  party_affiliation: "Independent",
  description: "U.S. Senator and progressive political figure. Two-time presidential candidate (2016, 2020).",
  image_url: "https://upload.wikimedia.org/wikipedia/commons/thumb/d/de/Bernie_Sanders.jpg/200px-Bernie_Sanders.jpg",
  active: true,
  metadata: {
    birth_year: 1941,
    position: "Senator",
    state: "Vermont"
  }
)

ron_desantis = Actor.create!(
  name: "Ron DeSantis",
  actor_type: "personality",
  country: "United States",
  role: "Governor of Florida",
  party_affiliation: "Republican Party",
  description: "46th Governor of Florida, serving since 2019. Former U.S. Representative.",
  image_url: "https://upload.wikimedia.org/wikipedia/commons/thumb/f/f6/Ron_DeSantis_official_portrait_%28cropped%29.jpg/200px-Ron_DeSantis_official_portrait_%28cropped%29.jpg",
  active: true,
  metadata: {
    birth_year: 1978,
    position: "Governor",
    state: "Florida",
    term_start: "2019-01-08"
  }
)

puts "    ✓ Created #{Actor.count} actors"

