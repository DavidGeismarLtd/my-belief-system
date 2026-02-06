require 'rails_helper'

RSpec.describe UserValuePortrait, type: :model do
  describe 'associations' do
    it { should belong_to(:user) }
    it { should belong_to(:value_dimension) }
  end

  describe 'validations' do
    subject { build(:user_value_portrait) }

    it { should validate_presence_of(:position) }
    it { should validate_numericality_of(:position).is_greater_than_or_equal_to(-100) }
    it { should validate_numericality_of(:position).is_less_than_or_equal_to(100) }
    it { should validate_numericality_of(:intensity).is_greater_than_or_equal_to(0).allow_nil }
    it { should validate_numericality_of(:intensity).is_less_than_or_equal_to(100).allow_nil }
    it { should validate_numericality_of(:confidence).is_greater_than_or_equal_to(0).allow_nil }
    it { should validate_numericality_of(:confidence).is_less_than_or_equal_to(100).allow_nil }

    it 'validates uniqueness of user_id scoped to value_dimension_id' do
      user = create(:user)
      dimension = create(:value_dimension)
      create(:user_value_portrait, user: user, value_dimension: dimension)

      duplicate = build(:user_value_portrait, user: user, value_dimension: dimension)
      expect(duplicate).not_to be_valid
      expect(duplicate.errors[:user_id]).to be_present
    end
  end

  describe 'scopes' do
    let!(:high_conf_portrait) { create(:user_value_portrait, confidence: 80) }
    let!(:low_conf_portrait) { create(:user_value_portrait, confidence: 40) }
    let!(:strong_left_portrait) { create(:user_value_portrait, position: -60) }
    let!(:strong_right_portrait) { create(:user_value_portrait, position: 60) }
    let!(:moderate_portrait) { create(:user_value_portrait, position: 30) }

    describe '.high_confidence' do
      it 'returns portraits with confidence >= 70' do
        expect(UserValuePortrait.high_confidence).to include(high_conf_portrait)
        expect(UserValuePortrait.high_confidence).not_to include(low_conf_portrait)
      end
    end

    describe '.low_confidence' do
      it 'returns portraits with confidence < 50' do
        expect(UserValuePortrait.low_confidence).to include(low_conf_portrait)
        expect(UserValuePortrait.low_confidence).not_to include(high_conf_portrait)
      end
    end

    describe '.strong_position' do
      it 'returns portraits with absolute position >= 50' do
        expect(UserValuePortrait.strong_position).to include(strong_left_portrait, strong_right_portrait)
        expect(UserValuePortrait.strong_position).not_to include(moderate_portrait)
      end
    end

    describe '.moderate_position' do
      it 'returns portraits with absolute position < 50' do
        expect(UserValuePortrait.moderate_position).to include(moderate_portrait)
        expect(UserValuePortrait.moderate_position).not_to include(strong_left_portrait, strong_right_portrait)
      end
    end
  end

  describe '#left_leaning?' do
    it 'returns true when position is negative' do
      portrait = build(:user_value_portrait, position: -30)
      expect(portrait.left_leaning?).to be true
    end

    it 'returns false when position is positive' do
      portrait = build(:user_value_portrait, position: 30)
      expect(portrait.left_leaning?).to be false
    end
  end

  describe '#right_leaning?' do
    it 'returns true when position is positive' do
      portrait = build(:user_value_portrait, position: 30)
      expect(portrait.right_leaning?).to be true
    end

    it 'returns false when position is negative' do
      portrait = build(:user_value_portrait, position: -30)
      expect(portrait.right_leaning?).to be false
    end
  end

  describe '#centrist?' do
    it 'returns true when absolute position < 20' do
      portrait = build(:user_value_portrait, position: 15)
      expect(portrait.centrist?).to be true

      portrait.position = -15
      expect(portrait.centrist?).to be true
    end

    it 'returns false when absolute position >= 20' do
      portrait = build(:user_value_portrait, position: 25)
      expect(portrait.centrist?).to be false
    end
  end

  describe '#strong?' do
    it 'returns true when absolute position >= 50' do
      portrait = build(:user_value_portrait, position: 60)
      expect(portrait.strong?).to be true

      portrait.position = -60
      expect(portrait.strong?).to be true
    end

    it 'returns false when absolute position < 50' do
      portrait = build(:user_value_portrait, position: 40)
      expect(portrait.strong?).to be false
    end
  end

  describe '#moderate?' do
    it 'returns true when 20 <= absolute position < 50' do
      portrait = build(:user_value_portrait, position: 30)
      expect(portrait.moderate?).to be true

      portrait.position = -30
      expect(portrait.moderate?).to be true
    end

    it 'returns false when absolute position < 20' do
      portrait = build(:user_value_portrait, position: 15)
      expect(portrait.moderate?).to be false
    end

    it 'returns false when absolute position >= 50' do
      portrait = build(:user_value_portrait, position: 60)
      expect(portrait.moderate?).to be false
    end
  end

  describe '#high_confidence?' do
    it 'returns true when confidence >= 70' do
      portrait = build(:user_value_portrait, confidence: 80)
      expect(portrait.high_confidence?).to be true
    end

    it 'returns false when confidence < 70' do
      portrait = build(:user_value_portrait, confidence: 60)
      expect(portrait.high_confidence?).to be false
    end

    it 'returns false when confidence is nil' do
      portrait = build(:user_value_portrait, confidence: nil)
      expect(portrait.high_confidence?).to be false
    end
  end

  describe '#low_confidence?' do
    it 'returns true when confidence < 50' do
      portrait = build(:user_value_portrait, confidence: 40)
      expect(portrait.low_confidence?).to be true
    end

    it 'returns false when confidence >= 50' do
      portrait = build(:user_value_portrait, confidence: 60)
      expect(portrait.low_confidence?).to be false
    end

    it 'returns false when confidence is nil' do
      portrait = build(:user_value_portrait, confidence: nil)
      expect(portrait.low_confidence?).to be false
    end
  end

  describe '#position_label' do
    let(:dimension) { create(:value_dimension, left_pole: 'Liberal', right_pole: 'Conservative') }

    it 'returns "Centrist" for centrist positions' do
      portrait = build(:user_value_portrait, value_dimension: dimension, position: 10)
      expect(portrait.position_label).to eq('Centrist')
    end

    it 'returns "Strong [left_pole]" for strong left positions' do
      portrait = build(:user_value_portrait, value_dimension: dimension, position: -60)
      expect(portrait.position_label).to eq('Strong Liberal')
    end

    it 'returns "Moderate [left_pole]" for moderate left positions' do
      portrait = build(:user_value_portrait, value_dimension: dimension, position: -30)
      expect(portrait.position_label).to eq('Moderate Liberal')
    end

    it 'returns "Strong [right_pole]" for strong right positions' do
      portrait = build(:user_value_portrait, value_dimension: dimension, position: 60)
      expect(portrait.position_label).to eq('Strong Conservative')
    end

    it 'returns "Moderate [right_pole]" for moderate right positions' do
      portrait = build(:user_value_portrait, value_dimension: dimension, position: 30)
      expect(portrait.position_label).to eq('Moderate Conservative')
    end
  end

  describe '#to_s' do
    it 'returns a string representation' do
      user = create(:user, email: 'test@example.com')
      dimension = create(:value_dimension, name: 'Test Dimension')
      portrait = create(:user_value_portrait, user: user, value_dimension: dimension, position: 50)

      expect(portrait.to_s).to eq('test@example.com - Test Dimension: 50.0')
    end
  end
end
