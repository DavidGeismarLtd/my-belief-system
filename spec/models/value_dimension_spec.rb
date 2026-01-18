require 'rails_helper'

RSpec.describe ValueDimension, type: :model do
  describe 'associations' do
    it { should have_many(:questions).dependent(:destroy) }
    it { should have_many(:user_value_portraits).dependent(:destroy) }
    it { should have_many(:users).through(:user_value_portraits) }
  end

  describe 'validations' do
    subject { build(:value_dimension) }

    it { should validate_presence_of(:key) }
    it { should validate_uniqueness_of(:key) }
    it { should validate_presence_of(:name) }
    it { should validate_presence_of(:left_pole) }
    it { should validate_presence_of(:right_pole) }
    it { should validate_presence_of(:position) }
    it { should validate_numericality_of(:position).only_integer }
    it { should validate_numericality_of(:position).is_greater_than_or_equal_to(0) }

    it 'validates key format (lowercase and underscores only)' do
      dimension = build(:value_dimension, key: 'valid_key')
      expect(dimension).to be_valid

      dimension.key = 'InvalidKey'
      expect(dimension).not_to be_valid
      expect(dimension.errors[:key]).to include('only allows lowercase letters and underscores')

      dimension.key = 'invalid-key'
      expect(dimension).not_to be_valid

      dimension.key = 'invalid key'
      expect(dimension).not_to be_valid
    end
  end

  describe 'scopes' do
    let!(:active_dimension) { create(:value_dimension, active: true, position: 1) }
    let!(:inactive_dimension) { create(:value_dimension, active: false, position: 2) }
    let!(:dimension_with_questions) { create(:value_dimension, :with_questions, position: 3) }

    describe '.active' do
      it 'returns only active dimensions' do
        expect(ValueDimension.active).to include(active_dimension)
        expect(ValueDimension.active).not_to include(inactive_dimension)
      end
    end

    describe '.ordered' do
      it 'returns dimensions ordered by position' do
        expect(ValueDimension.ordered.first).to eq(active_dimension)
        expect(ValueDimension.ordered.last).to eq(dimension_with_questions)
      end
    end

    describe '.with_questions' do
      it 'returns only dimensions that have questions' do
        expect(ValueDimension.with_questions).to include(dimension_with_questions)
        expect(ValueDimension.with_questions).not_to include(active_dimension)
      end
    end
  end

  describe '#question_count' do
    let(:dimension) { create(:value_dimension) }

    it 'returns the number of active questions' do
      create_list(:question, 3, value_dimension: dimension, active: true)
      create(:question, value_dimension: dimension, active: false)

      expect(dimension.question_count).to eq(3)
    end
  end

  describe '#user_count' do
    let(:dimension) { create(:value_dimension) }
    let(:user1) { create(:user) }
    let(:user2) { create(:user) }

    it 'returns the number of distinct users with portraits for this dimension' do
      create(:user_value_portrait, value_dimension: dimension, user: user1)
      create(:user_value_portrait, value_dimension: dimension, user: user2)

      expect(dimension.user_count).to eq(2)
    end
  end

  describe '#average_position' do
    let(:dimension) { create(:value_dimension) }

    it 'returns the average position across all user portraits' do
      create(:user_value_portrait, value_dimension: dimension, position: 50.0)
      create(:user_value_portrait, value_dimension: dimension, position: 70.0)
      create(:user_value_portrait, value_dimension: dimension, position: 80.0)

      # average returns BigDecimal, so convert to float for comparison
      expect(dimension.average_position.to_f).to be_within(0.01).of(66.67)
    end

    it 'returns nil when no portraits exist' do
      expect(dimension.average_position).to be_nil
    end
  end

  describe '#display_name' do
    let(:dimension) { create(:value_dimension, name: 'Test Dimension') }

    it 'returns the name' do
      expect(dimension.display_name).to eq('Test Dimension')
    end
  end

  describe '#poles' do
    let(:dimension) { create(:value_dimension, left_pole: 'Left', right_pole: 'Right') }

    it 'returns an array of left and right poles' do
      expect(dimension.poles).to eq(['Left', 'Right'])
    end
  end

  describe '#to_s' do
    let(:dimension) { create(:value_dimension, name: 'Test Dimension') }

    it 'returns the name' do
      expect(dimension.to_s).to eq('Test Dimension')
    end
  end
end
