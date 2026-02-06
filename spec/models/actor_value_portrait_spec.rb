require 'rails_helper'

RSpec.describe ActorValuePortrait, type: :model do
  describe 'associations' do
    it { should belong_to(:actor) }
    it { should belong_to(:value_dimension) }
  end

  describe 'validations' do
    subject { build(:actor_value_portrait) }

    it { should validate_presence_of(:position) }
    it { should validate_numericality_of(:position).is_greater_than_or_equal_to(-100) }
    it { should validate_numericality_of(:position).is_less_than_or_equal_to(100) }
    it { should validate_numericality_of(:intensity).is_greater_than_or_equal_to(0).allow_nil }
    it { should validate_numericality_of(:intensity).is_less_than_or_equal_to(100).allow_nil }
    it { should validate_numericality_of(:confidence).is_greater_than_or_equal_to(0).allow_nil }
    it { should validate_numericality_of(:confidence).is_less_than_or_equal_to(100).allow_nil }

    it 'validates uniqueness of actor_id scoped to value_dimension_id' do
      actor = create(:actor)
      dimension = create(:value_dimension)
      create(:actor_value_portrait, actor: actor, value_dimension: dimension)

      duplicate = build(:actor_value_portrait, actor: actor, value_dimension: dimension)
      expect(duplicate).not_to be_valid
      expect(duplicate.errors[:actor_id]).to be_present
    end
  end

  describe 'scopes' do
    let!(:high_conf_portrait) { create(:actor_value_portrait, confidence: 80) }
    let!(:low_conf_portrait) { create(:actor_value_portrait, confidence: 40) }
    let!(:strong_portrait) { create(:actor_value_portrait, position: 70) }
    let!(:moderate_portrait) { create(:actor_value_portrait, position: 30) }

    describe '.high_confidence' do
      it 'returns portraits with confidence >= 70' do
        expect(ActorValuePortrait.high_confidence).to include(high_conf_portrait)
        expect(ActorValuePortrait.high_confidence).not_to include(low_conf_portrait)
      end
    end

    describe '.low_confidence' do
      it 'returns portraits with confidence < 50' do
        expect(ActorValuePortrait.low_confidence).to include(low_conf_portrait)
        expect(ActorValuePortrait.low_confidence).not_to include(high_conf_portrait)
      end
    end

    describe '.strong_position' do
      it 'returns portraits with absolute position >= 50' do
        expect(ActorValuePortrait.strong_position).to include(strong_portrait)
        expect(ActorValuePortrait.strong_position).not_to include(moderate_portrait)
      end
    end

    describe '.moderate_position' do
      it 'returns portraits with absolute position < 50' do
        expect(ActorValuePortrait.moderate_position).to include(moderate_portrait)
        expect(ActorValuePortrait.moderate_position).not_to include(strong_portrait)
      end
    end
  end

  describe 'instance methods' do
    describe '#left_leaning?' do
      it 'returns true when position is negative' do
        portrait = build(:actor_value_portrait, position: -50)
        expect(portrait.left_leaning?).to be true
      end

      it 'returns false when position is positive' do
        portrait = build(:actor_value_portrait, position: 50)
        expect(portrait.left_leaning?).to be false
      end
    end

    describe '#right_leaning?' do
      it 'returns true when position is positive' do
        portrait = build(:actor_value_portrait, position: 50)
        expect(portrait.right_leaning?).to be true
      end

      it 'returns false when position is negative' do
        portrait = build(:actor_value_portrait, position: -50)
        expect(portrait.right_leaning?).to be false
      end
    end

    describe '#centrist?' do
      it 'returns true when absolute position < 20' do
        portrait = build(:actor_value_portrait, position: 15)
        expect(portrait.centrist?).to be true
      end

      it 'returns false when absolute position >= 20' do
        portrait = build(:actor_value_portrait, position: 25)
        expect(portrait.centrist?).to be false
      end
    end

    describe '#strong?' do
      it 'returns true when absolute position >= 50' do
        portrait = build(:actor_value_portrait, position: -60)
        expect(portrait.strong?).to be true
      end

      it 'returns false when absolute position < 50' do
        portrait = build(:actor_value_portrait, position: 40)
        expect(portrait.strong?).to be false
      end
    end

    describe '#moderate?' do
      it 'returns true when absolute position is between 20 and 50' do
        portrait = build(:actor_value_portrait, position: 30)
        expect(portrait.moderate?).to be true
      end

      it 'returns false when absolute position < 20' do
        portrait = build(:actor_value_portrait, position: 15)
        expect(portrait.moderate?).to be false
      end

      it 'returns false when absolute position >= 50' do
        portrait = build(:actor_value_portrait, position: 60)
        expect(portrait.moderate?).to be false
      end
    end

    describe '#high_confidence?' do
      it 'returns true when confidence >= 70' do
        portrait = build(:actor_value_portrait, confidence: 80)
        expect(portrait.high_confidence?).to be true
      end

      it 'returns false when confidence < 70' do
        portrait = build(:actor_value_portrait, confidence: 60)
        expect(portrait.high_confidence?).to be false
      end

      it 'returns false when confidence is nil' do
        portrait = build(:actor_value_portrait, confidence: nil)
        expect(portrait.high_confidence?).to be false
      end
    end
  end
end
