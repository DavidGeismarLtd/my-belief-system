require 'rails_helper'

RSpec.describe Intervention, type: :model do
  describe 'associations' do
    it { should belong_to(:actor) }
  end

  describe 'validations' do
    it { should validate_presence_of(:intervention_type) }
    it { should validate_inclusion_of(:intervention_type).in_array(Intervention::INTERVENTION_TYPES) }
    it { should validate_presence_of(:content) }
  end

  describe 'scopes' do
    let(:actor) { create(:actor, :personality) }
    let!(:active_intervention) { create(:intervention, actor: actor, active: true) }
    let!(:inactive_intervention) { create(:intervention, actor: actor, active: false) }
    let!(:recent_intervention) { create(:intervention, actor: actor, published_at: 1.day.ago) }
    let!(:old_intervention) { create(:intervention, actor: actor, published_at: 1.year.ago) }
    let!(:tweet) { create(:intervention, :tweet, actor: actor) }
    let!(:video) { create(:intervention, :video, actor: actor) }
    let!(:speech) { create(:intervention, :speech, actor: actor) }
    let!(:declaration) { create(:intervention, :declaration, actor: actor) }

    describe '.active' do
      it 'returns only active interventions' do
        expect(Intervention.active).to include(active_intervention)
        expect(Intervention.active).not_to include(inactive_intervention)
      end
    end

    describe '.recent' do
      it 'returns interventions ordered by published_at descending' do
        expect(Intervention.recent.first).to eq(recent_intervention)
      end
    end

    describe '.by_type' do
      it 'returns interventions of specified type' do
        expect(Intervention.by_type('tweet')).to include(tweet)
        expect(Intervention.by_type('tweet')).not_to include(video)
      end
    end

    describe '.tweets' do
      it 'returns only tweet interventions' do
        expect(Intervention.tweets).to include(tweet)
        expect(Intervention.tweets).not_to include(video, speech)
      end
    end

    describe '.videos' do
      it 'returns only video interventions' do
        expect(Intervention.videos).to include(video)
        expect(Intervention.videos).not_to include(tweet, speech)
      end
    end

    describe '.speeches' do
      it 'returns only speech interventions' do
        expect(Intervention.speeches).to include(speech)
        expect(Intervention.speeches).not_to include(tweet, video)
      end
    end

    describe '.declarations' do
      it 'returns only declaration interventions' do
        expect(Intervention.declarations).to include(declaration)
        expect(Intervention.declarations).not_to include(tweet, video)
      end
    end
  end

  describe 'instance methods' do
    describe '#tweet?' do
      it 'returns true for tweet interventions' do
        tweet = create(:intervention, :tweet)
        expect(tweet.tweet?).to be true
      end

      it 'returns false for non-tweet interventions' do
        video = create(:intervention, :video)
        expect(video.tweet?).to be false
      end
    end

    describe '#video?' do
      it 'returns true for video interventions' do
        video = create(:intervention, :video)
        expect(video.video?).to be true
      end

      it 'returns false for non-video interventions' do
        tweet = create(:intervention, :tweet)
        expect(tweet.video?).to be false
      end
    end

    describe '#platform_icon' do
      it 'returns correct icon for twitter' do
        intervention = create(:intervention, source_platform: 'twitter')
        expect(intervention.platform_icon).to eq('𝕏')
      end

      it 'returns correct icon for youtube' do
        intervention = create(:intervention, source_platform: 'youtube')
        expect(intervention.platform_icon).to eq('▶️')
      end

      it 'returns correct icon for press_release' do
        intervention = create(:intervention, source_platform: 'press_release')
        expect(intervention.platform_icon).to eq('📰')
      end

      it 'returns default icon for unknown platform' do
        intervention = create(:intervention, source_platform: 'unknown')
        expect(intervention.platform_icon).to eq('🔗')
      end
    end

    describe '#display_type' do
      it 'returns capitalized intervention type' do
        intervention = create(:intervention, intervention_type: 'tweet')
        expect(intervention.display_type).to eq('Tweet')
      end
    end
  end

  describe 'metadata' do
    it 'stores and retrieves metadata as JSON' do
      intervention = create(:intervention, metadata: { views: 1000, likes: 500 })
      expect(intervention.metadata['views']).to eq(1000)
      expect(intervention.metadata['likes']).to eq(500)
    end
  end

  describe 'published_at' do
    it 'can be queried by date range' do
      old = create(:intervention, published_at: 1.year.ago)
      recent = create(:intervention, published_at: 1.day.ago)

      results = Intervention.where('published_at > ?', 1.week.ago)
      expect(results).to include(recent)
      expect(results).not_to include(old)
    end
  end
end

