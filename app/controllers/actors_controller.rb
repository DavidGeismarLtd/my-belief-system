class ActorsController < ApplicationController
  def index
    @actors = mock_all_actors
  end

  def show
    @actor = mock_actor_detail(params[:id].to_i)
    @user_portrait = mock_user_portrait
  end

  private

  def mock_all_actors
    # Same as dashboard but without alignment scores
    [
      { id: 1, name: "Democratic Party", type: "Party", location: "National" },
      { id: 2, name: "Republican Party", type: "Party", location: "National" },
      { id: 3, name: "Joe Biden", type: "Personality", role: "President", party: "Democratic Party" },
      { id: 4, name: "Donald Trump", type: "Personality", role: "Former President", party: "Republican Party" },
      { id: 5, name: "Kamala Harris", type: "Personality", role: "Vice President", party: "Democratic Party" },
      { id: 6, name: "Ron DeSantis", type: "Personality", role: "Governor of Florida", party: "Republican Party" },
      { id: 7, name: "Bernie Sanders", type: "Personality", role: "Senator", party: "Independent" }
    ]
  end

  def mock_actor_detail(id)
    actors = {
      1 => {
        id: 1,
        name: "Democratic Party",
        type: "Party",
        location: "National",
        description: "One of the two major political parties in the United States",
        program_url: "https://democrats.org/where-we-stand/party-platform/",
        image_url: "https://upload.wikimedia.org/wikipedia/commons/thumb/0/02/DemocraticLogo.svg/200px-DemocraticLogo.svg.png",
        alignment_score: 72,
        dimensions: [
          { name: "Individual Liberty vs Collective Authority", actor_position: -30, user_position: -45, alignment: 85 },
          { name: "Economic Equality vs Free Market", actor_position: -60, user_position: -55, alignment: 92 },
          { name: "Environmental Protection vs Economic Growth", actor_position: -70, user_position: -65, alignment: 94 },
          { name: "National Sovereignty vs Global Cooperation", actor_position: 40, user_position: -20, alignment: 40 },
          { name: "Traditional Values vs Progressive Values", actor_position: 50, user_position: 45, alignment: 90 },
          { name: "Law & Order vs Criminal Justice Reform", actor_position: 35, user_position: 40, alignment: 88 },
          { name: "Direct Democracy vs Representative Democracy", actor_position: -10, user_position: 15, alignment: 75 },
          { name: "Meritocracy vs Equal Outcomes", actor_position: 45, user_position: 50, alignment: 90 }
        ]
      },
      3 => {
        id: 3,
        name: "Joe Biden",
        type: "Personality",
        role: "President",
        party: "Democratic Party",
        description: "46th President of the United States",
        image_url: "https://upload.wikimedia.org/wikipedia/commons/thumb/6/68/Joe_Biden_presidential_portrait.jpg/200px-Joe_Biden_presidential_portrait.jpg",
        alignment_score: 68,
        interventions: [
          {
            type: "tweet",
            platform: "twitter",
            content: "We're building an economy from the bottom up and the middle out – not the top down.",
            published_at: 2.days.ago,
            source_url: "https://twitter.com/POTUS/status/example"
          },
          {
            type: "speech",
            platform: "press_release",
            content: "Today, I'm announcing new measures to combat climate change and create millions of good-paying jobs in clean energy.",
            published_at: 5.days.ago,
            source_url: "https://whitehouse.gov/briefing-room/example"
          },
          {
            type: "video",
            platform: "youtube",
            content: "State of the Union Address 2024 - Full Speech",
            published_at: 1.week.ago,
            source_url: "https://youtube.com/watch?v=example"
          }
        ],
        dimensions: [
          { name: "Individual Liberty vs Collective Authority", actor_position: -25, user_position: -45, alignment: 78 },
          { name: "Economic Equality vs Free Market", actor_position: -45, user_position: -55, alignment: 85 },
          { name: "Environmental Protection vs Economic Growth", actor_position: -55, user_position: -65, alignment: 87 },
          { name: "National Sovereignty vs Global Cooperation", actor_position: 60, user_position: -20, alignment: 20 },
          { name: "Traditional Values vs Progressive Values", actor_position: 30, user_position: 45, alignment: 82 },
          { name: "Law & Order vs Criminal Justice Reform", actor_position: 50, user_position: 40, alignment: 85 },
          { name: "Direct Democracy vs Representative Democracy", actor_position: -30, user_position: 15, alignment: 55 },
          { name: "Meritocracy vs Equal Outcomes", actor_position: 35, user_position: 50, alignment: 82 }
        ]
      }
    }

    actors[id] || actors[1]
  end

  def mock_user_portrait
    {
      dimensions: [
        { name: "Individual Liberty vs Collective Authority", position: -45 },
        { name: "Economic Equality vs Free Market", position: -55 },
        { name: "Environmental Protection vs Economic Growth", position: -65 },
        { name: "National Sovereignty vs Global Cooperation", position: -20 },
        { name: "Traditional Values vs Progressive Values", position: 45 },
        { name: "Law & Order vs Criminal Justice Reform", position: 40 },
        { name: "Direct Democracy vs Representative Democracy", position: 15 },
        { name: "Meritocracy vs Equal Outcomes", position: 50 }
      ]
    }
  end
end
