class ValuePortraitsController < ApplicationController
  def show
    @portrait = mock_user_portrait
  end

  private

  def mock_user_portrait
    {
      created_at: 2.weeks.ago,
      dimensions: [
        {
          name: "Individual Liberty vs Collective Authority",
          position: -45,
          intensity: 75,
          confidence: 85,
          left_pole: "Individual Liberty",
          right_pole: "Collective Authority",
          explanation: "You strongly agreed that personal freedom is more important than collective security in most situations."
        },
        {
          name: "Economic Equality vs Free Market",
          position: -55,
          intensity: 82,
          confidence: 90,
          left_pole: "Economic Equality",
          right_pole: "Free Market",
          explanation: "Your answers indicate a strong preference for reducing economic inequality through government intervention."
        },
        {
          name: "Environmental Protection vs Economic Growth",
          position: -65,
          intensity: 88,
          confidence: 92,
          left_pole: "Environmental Protection",
          right_pole: "Economic Growth",
          explanation: "You consistently prioritized environmental protection over short-term economic gains."
        },
        {
          name: "National Sovereignty vs Global Cooperation",
          position: -20,
          intensity: 45,
          confidence: 65,
          left_pole: "National Sovereignty",
          right_pole: "Global Cooperation",
          explanation: "You showed a slight preference for national sovereignty, though with moderate confidence."
        },
        {
          name: "Traditional Values vs Progressive Values",
          position: 45,
          intensity: 70,
          confidence: 80,
          left_pole: "Traditional Values",
          right_pole: "Progressive Values",
          explanation: "Your responses lean toward progressive social values on most issues."
        },
        {
          name: "Law & Order vs Criminal Justice Reform",
          position: 40,
          intensity: 65,
          confidence: 75,
          left_pole: "Law & Order",
          right_pole: "Criminal Justice Reform",
          explanation: "You favor criminal justice reform while maintaining some emphasis on public safety."
        },
        {
          name: "Direct Democracy vs Representative Democracy",
          position: 15,
          intensity: 50,
          confidence: 60,
          left_pole: "Direct Democracy",
          right_pole: "Representative Democracy",
          explanation: "You showed a slight preference for representative democracy with some direct participation."
        },
        {
          name: "Meritocracy vs Equal Outcomes",
          position: 50,
          intensity: 72,
          confidence: 78,
          left_pole: "Meritocracy",
          right_pole: "Equal Outcomes",
          explanation: "You believe in ensuring equal outcomes to address systemic inequalities."
        }
      ]
    }
  end
end
