puts "  Creating interventions..."

# Clear existing interventions
Intervention.destroy_all

# Get actors
joe_biden = Actor.find_by(name: "Joe Biden")
donald_trump = Actor.find_by(name: "Donald Trump")
kamala_harris = Actor.find_by(name: "Kamala Harris")
bernie_sanders = Actor.find_by(name: "Bernie Sanders")
ron_desantis = Actor.find_by(name: "Ron DeSantis")

# ============================================================================
# JOE BIDEN INTERVENTIONS
# ============================================================================

if joe_biden
  Intervention.create!([
    {
      actor: joe_biden,
      intervention_type: "tweet",
      content: "We're building an economy from the bottom up and the middle out – not the top down. That's Bidenomics.",
      source_url: "https://twitter.com/POTUS",
      source_platform: "twitter",
      published_at: 2.days.ago,
      active: true
    },
    {
      actor: joe_biden,
      intervention_type: "speech",
      content: "Today, I'm announcing new measures to combat climate change and create millions of good-paying jobs in clean energy. We're investing $369 billion in climate action through the Inflation Reduction Act.",
      source_url: "https://www.whitehouse.gov/briefing-room/",
      source_platform: "press_release",
      published_at: 5.days.ago,
      active: true
    },
    {
      actor: joe_biden,
      intervention_type: "video",
      content: "State of the Union Address 2024 - Discussing infrastructure, healthcare, and economic recovery.",
      source_url: "https://www.youtube.com/watch?v=example",
      source_platform: "youtube",
      published_at: 1.week.ago,
      active: true
    },
    {
      actor: joe_biden,
      intervention_type: "declaration",
      content: "I'm proud to announce student debt relief for millions of Americans. No one should be denied opportunity because of the cost of education.",
      source_url: "https://www.whitehouse.gov/briefing-room/",
      source_platform: "press_release",
      published_at: 2.weeks.ago,
      active: true
    },
    {
      actor: joe_biden,
      intervention_type: "tweet",
      content: "Healthcare is a right, not a privilege. We're working to lower prescription drug costs and protect the Affordable Care Act.",
      source_url: "https://twitter.com/POTUS",
      source_platform: "twitter",
      published_at: 3.weeks.ago,
      active: true
    }
  ])
end

# ============================================================================
# DONALD TRUMP INTERVENTIONS
# ============================================================================

if donald_trump
  Intervention.create!([
    {
      actor: donald_trump,
      intervention_type: "tweet",
      content: "America First! We need to bring back manufacturing jobs and stop unfair trade deals that hurt American workers.",
      source_url: "https://twitter.com/realDonaldTrump",
      source_platform: "twitter",
      published_at: 1.day.ago,
      active: true
    },
    {
      actor: donald_trump,
      intervention_type: "speech",
      content: "Rally speech in Iowa: We're going to secure our borders, cut taxes, and make America great again. The radical left has destroyed our country.",
      source_url: "https://www.donaldjtrump.com/",
      source_platform: "website",
      published_at: 4.days.ago,
      active: true
    },
    {
      actor: donald_trump,
      intervention_type: "declaration",
      content: "The 2020 election was rigged and stolen. We need election integrity and voter ID laws in every state.",
      source_url: "https://www.donaldjtrump.com/",
      source_platform: "press_release",
      published_at: 1.week.ago,
      active: true
    },
    {
      actor: donald_trump,
      intervention_type: "tweet",
      content: "Fake News Media is the enemy of the people. They lie about everything I do. We need to drain the swamp!",
      source_url: "https://twitter.com/realDonaldTrump",
      source_platform: "twitter",
      published_at: 10.days.ago,
      active: true
    }
  ])
end

# ============================================================================
# KAMALA HARRIS INTERVENTIONS
# ============================================================================

if kamala_harris
  Intervention.create!([
    {
      actor: kamala_harris,
      intervention_type: "tweet",
      content: "Reproductive rights are under attack. We must protect a woman's right to make decisions about her own body.",
      source_url: "https://twitter.com/VP",
      source_platform: "twitter",
      published_at: 3.days.ago,
      active: true
    },
    {
      actor: kamala_harris,
      intervention_type: "speech",
      content: "Speech on criminal justice reform: We need to end mass incarceration and address systemic racism in our justice system.",
      source_url: "https://www.whitehouse.gov/briefing-room/",
      source_platform: "press_release",
      published_at: 1.week.ago,
      active: true
    },
    {
      actor: kamala_harris,
      intervention_type: "video",
      content: "Town hall on voting rights: Every American deserves access to the ballot box. We're fighting voter suppression laws.",
      source_url: "https://www.youtube.com/watch?v=example",
      source_platform: "youtube",
      published_at: 2.weeks.ago,
      active: true
    }
  ])
end

# ============================================================================
# BERNIE SANDERS INTERVENTIONS
# ============================================================================

if bernie_sanders
  Intervention.create!([
    {
      actor: bernie_sanders,
      intervention_type: "tweet",
      content: "The billionaire class is getting richer while working families struggle. We need Medicare for All, a $15 minimum wage, and to tax the rich.",
      source_url: "https://twitter.com/BernieSanders",
      source_platform: "twitter",
      published_at: 1.day.ago,
      active: true
    },
    {
      actor: bernie_sanders,
      intervention_type: "speech",
      content: "Senate floor speech on income inequality: The top 1% owns more wealth than the bottom 90%. This is a moral and economic outrage.",
      source_url: "https://www.sanders.senate.gov/",
      source_platform: "website",
      published_at: 6.days.ago,
      active: true
    },
    {
      actor: bernie_sanders,
      intervention_type: "tweet",
      content: "Climate change is an existential threat. We need a Green New Deal to transform our energy system and create 20 million jobs.",
      source_url: "https://twitter.com/BernieSanders",
      source_platform: "twitter",
      published_at: 2.weeks.ago,
      active: true
    },
    {
      actor: bernie_sanders,
      intervention_type: "declaration",
      content: "College should be tuition-free and we must cancel all student debt. Education is a right, not a commodity.",
      source_url: "https://www.sanders.senate.gov/",
      source_platform: "press_release",
      published_at: 3.weeks.ago,
      active: true
    }
  ])
end

# ============================================================================
# RON DESANTIS INTERVENTIONS
# ============================================================================

if ron_desantis
  Intervention.create!([
    {
      actor: ron_desantis,
      intervention_type: "tweet",
      content: "Florida is leading the nation in freedom. We reject woke ideology and stand up for parents' rights in education.",
      source_url: "https://twitter.com/GovRonDeSantis",
      source_platform: "twitter",
      published_at: 2.days.ago,
      active: true
    },
    {
      actor: ron_desantis,
      intervention_type: "speech",
      content: "Press conference on education: We're banning critical race theory and gender ideology from our schools. Parents, not bureaucrats, should decide what kids learn.",
      source_url: "https://www.flgov.com/",
      source_platform: "press_release",
      published_at: 1.week.ago,
      active: true
    },
    {
      actor: ron_desantis,
      intervention_type: "declaration",
      content: "Florida is open for business. We have low taxes, no lockdowns, and we're attracting businesses from across the country.",
      source_url: "https://www.flgov.com/",
      source_platform: "press_release",
      published_at: 2.weeks.ago,
      active: true
    },
    {
      actor: ron_desantis,
      intervention_type: "tweet",
      content: "We're fighting back against Big Tech censorship and protecting Floridians' free speech rights.",
      source_url: "https://twitter.com/GovRonDeSantis",
      source_platform: "twitter",
      published_at: 3.weeks.ago,
      active: true
    }
  ])
end

puts "    ✓ Created #{Intervention.count} interventions"
