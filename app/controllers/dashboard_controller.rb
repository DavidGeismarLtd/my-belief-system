class DashboardController < ApplicationController
  def index
    @actors = mock_actors_with_alignment
  end

  private

  def mock_actors_with_alignment
    [
      {
        id: 1,
        name: "Democratic Party",
        type: "Party",
        location: "National",
        image_url: "https://upload.wikimedia.org/wikipedia/commons/thumb/0/02/DemocraticLogo.svg/200px-DemocraticLogo.svg.png",
        alignment_score: 72,
        alignment_label: "Strong",
        alignment_color: "green",
        strong_dimensions: ["Environmental Protection", "Economic Equality"],
        weak_dimensions: ["National Sovereignty"],
        trend: "down",
        trend_value: 0.08
      },
      {
        id: 2,
        name: "Republican Party",
        type: "Party",
        location: "National",
        image_url: "https://upload.wikimedia.org/wikipedia/commons/thumb/9/9b/Republicanlogo.svg/200px-Republicanlogo.svg.png",
        alignment_score: 38,
        alignment_label: "Weak",
        alignment_color: "amber",
        strong_dimensions: ["Free Market", "Traditional Values"],
        weak_dimensions: ["Environmental Protection"],
        trend: "up",
        trend_value: 0.05
      },
      {
        id: 3,
        name: "Joe Biden",
        type: "Personality",
        role: "President",
        party: "Democratic Party",
        image_url: "https://upload.wikimedia.org/wikipedia/commons/thumb/6/68/Joe_Biden_presidential_portrait.jpg/200px-Joe_Biden_presidential_portrait.jpg",
        alignment_score: 68,
        alignment_label: "Moderate",
        alignment_color: "blue",
        strong_dimensions: ["Global Cooperation", "Criminal Justice Reform"],
        weak_dimensions: ["Direct Democracy"],
        trend: "stable",
        trend_value: 0.02
      },
      {
        id: 4,
        name: "Donald Trump",
        type: "Personality",
        role: "Former President",
        party: "Republican Party",
        image_url: "https://upload.wikimedia.org/wikipedia/commons/thumb/5/56/Donald_Trump_official_portrait.jpg/200px-Donald_Trump_official_portrait.jpg",
        alignment_score: 25,
        alignment_label: "Misalignment",
        alignment_color: "red",
        strong_dimensions: ["National Sovereignty", "Law & Order"],
        weak_dimensions: ["Environmental Protection", "Global Cooperation"],
        trend: "down",
        trend_value: 0.12
      },
      {
        id: 5,
        name: "Kamala Harris",
        type: "Personality",
        role: "Vice President",
        party: "Democratic Party",
        image_url: "https://upload.wikimedia.org/wikipedia/commons/thumb/4/41/Kamala_Harris_Vice_Presidential_Portrait.jpg/200px-Kamala_Harris_Vice_Presidential_Portrait.jpg",
        alignment_score: 75,
        alignment_label: "Strong",
        alignment_color: "green",
        strong_dimensions: ["Criminal Justice Reform", "Economic Equality"],
        weak_dimensions: ["Free Market"],
        trend: "up",
        trend_value: 0.06
      },
      {
        id: 6,
        name: "Ron DeSantis",
        type: "Personality",
        role: "Governor of Florida",
        party: "Republican Party",
        image_url: "https://upload.wikimedia.org/wikipedia/commons/thumb/f/f6/Ron_DeSantis_official_portrait_%28cropped%29.jpg/200px-Ron_DeSantis_official_portrait_%28cropped%29.jpg",
        alignment_score: 32,
        alignment_label: "Weak",
        alignment_color: "amber",
        strong_dimensions: ["Traditional Values", "Law & Order"],
        weak_dimensions: ["Progressive Values", "Environmental Protection"],
        trend: "stable",
        trend_value: 0.01
      },
      {
        id: 7,
        name: "Bernie Sanders",
        type: "Personality",
        role: "Senator",
        party: "Independent",
        image_url: "https://upload.wikimedia.org/wikipedia/commons/thumb/d/de/Bernie_Sanders.jpg/200px-Bernie_Sanders.jpg",
        alignment_score: 82,
        alignment_label: "Strong",
        alignment_color: "green",
        strong_dimensions: ["Economic Equality", "Environmental Protection", "Criminal Justice Reform"],
        weak_dimensions: ["Free Market"],
        trend: "up",
        trend_value: 0.04
      }
    ]
  end
end
