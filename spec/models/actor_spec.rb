require 'rails_helper'

RSpec.describe Actor, type: :model do
  describe 'associations' do
    it { should have_many(:interventions).dependent(:destroy) }
    it { should have_many(:actor_value_portraits).dependent(:destroy) }
    it { should have_many(:value_dimensions).through(:actor_value_portraits) }
  end

  describe 'validations' do
    it { should validate_presence_of(:name) }
    it { should validate_presence_of(:actor_type) }
    it { should validate_inclusion_of(:actor_type).in_array(Actor::ACTOR_TYPES) }
  end

  describe 'scopes' do
    let!(:active_actor) { create(:actor, active: true) }
    let!(:inactive_actor) { create(:actor, active: false) }
    let!(:us_actor) { create(:actor, country: 'United States') }
    let!(:france_actor) { create(:actor, country: 'France') }
    let!(:party) { create(:actor, :party) }
    let!(:personality) { create(:actor, :personality) }
    let!(:organization) { create(:actor, :organization) }

    describe '.active' do
      it 'returns only active actors' do
        expect(Actor.active).to include(active_actor)
        expect(Actor.active).not_to include(inactive_actor)
      end
    end

    describe '.by_country' do
      it 'returns actors from specified country' do
        expect(Actor.by_country('United States')).to include(us_actor)
        expect(Actor.by_country('United States')).not_to include(france_actor)
      end
    end

    describe '.parties' do
      it 'returns only party actors' do
        expect(Actor.parties).to include(party)
        expect(Actor.parties).not_to include(personality, organization)
      end
    end

    describe '.personalities' do
      it 'returns only personality actors' do
        expect(Actor.personalities).to include(personality)
        expect(Actor.personalities).not_to include(party, organization)
      end
    end

    describe '.organizations' do
      it 'returns only organization actors' do
        expect(Actor.organizations).to include(organization)
        expect(Actor.organizations).not_to include(party, personality)
      end
    end
  end

  describe 'instance methods' do
    describe '#party?' do
      it 'returns true for party actors' do
        party = create(:actor, :party)
        expect(party.party?).to be true
      end

      it 'returns false for non-party actors' do
        personality = create(:actor, :personality)
        expect(personality.party?).to be false
      end
    end

    describe '#personality?' do
      it 'returns true for personality actors' do
        personality = create(:actor, :personality)
        expect(personality.personality?).to be true
      end

      it 'returns false for non-personality actors' do
        party = create(:actor, :party)
        expect(party.personality?).to be false
      end
    end

    describe '#organization?' do
      it 'returns true for organization actors' do
        organization = create(:actor, :organization)
        expect(organization.organization?).to be true
      end

      it 'returns false for non-organization actors' do
        party = create(:actor, :party)
        expect(party.organization?).to be false
      end
    end

    describe '#display_type' do
      it 'returns capitalized actor type' do
        actor = create(:actor, actor_type: 'party')
        expect(actor.display_type).to eq('Party')
      end
    end

    describe '#initials' do
      it 'returns initials from name' do
        actor = create(:actor, name: 'Joe Biden')
        expect(actor.initials).to eq('JB')
      end

      it 'handles single word names' do
        actor = create(:actor, name: 'Madonna')
        expect(actor.initials).to eq('M')
      end

      it 'handles empty names' do
        actor = build(:actor, name: '')
        expect(actor.initials).to eq('')
      end
    end
  end

  describe 'metadata' do
    it 'stores and retrieves metadata as JSON' do
      actor = create(:actor, metadata: { founded: 1828, ideology: [ 'Progressivism' ] })
      expect(actor.metadata['founded']).to eq(1828)
      expect(actor.metadata['ideology']).to eq([ 'Progressivism' ])
    end
  end

  describe 'interventions association' do
    it 'destroys associated interventions when actor is destroyed' do
      actor = create(:actor, :personality)
      intervention = create(:intervention, actor: actor)

      expect { actor.destroy }.to change { Intervention.count }.by(-1)
    end
  end
end
