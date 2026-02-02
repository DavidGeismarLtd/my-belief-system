require 'rails_helper'

RSpec.describe 'shared/_dimension_card.html.erb', type: :view do
  describe 'rendering with required parameters' do
    it 'renders the dimension card with all required fields' do
      render partial: 'shared/dimension_card', locals: {
        dimension_name: 'Individual Liberty vs Authority',
        position: 45.5,
        intensity: 75.0,
        confidence: 80.0,
        left_pole: 'Individual Liberty',
        right_pole: 'Collective Authority',
        explanation: 'Based on your answers, you lean toward individual liberty.'
      }

      expect(rendered).to have_css('.bg-white\/80.backdrop-blur-sm.rounded-2xl')
      expect(rendered).to have_content('Individual Liberty vs Authority')
      expect(rendered).to have_content('Individual Liberty')
      expect(rendered).to have_content('Collective Authority')
      expect(rendered).to have_content('Position: 45.5')
    end

    it 'renders without optional parameters' do
      render partial: 'shared/dimension_card', locals: {
        dimension_name: 'Test Dimension',
        position: 0.0,
        intensity: 50.0,
        confidence: 60.0
      }

      expect(rendered).to have_content('Test Dimension')
      expect(rendered).to have_content('Position: 0.0')
      expect(rendered).to have_content('Left')
      expect(rendered).to have_content('Right')
    end
  end

  describe 'lean direction calculation' do
    it 'shows left pole label when position < -20' do
      render partial: 'shared/dimension_card', locals: {
        dimension_name: 'Test',
        position: -50.0,
        intensity: 50.0,
        confidence: 50.0,
        left_pole: 'Individual Liberty',
        right_pole: 'Collective Authority'
      }

      expect(rendered).to have_content('Individual')
      expect(rendered).not_to have_content('Balanced')
    end

    it 'shows right pole label when position > 20' do
      render partial: 'shared/dimension_card', locals: {
        dimension_name: 'Test',
        position: 50.0,
        intensity: 50.0,
        confidence: 50.0,
        left_pole: 'Individual Liberty',
        right_pole: 'Collective Authority'
      }

      expect(rendered).to have_content('Collective')
      expect(rendered).not_to have_content('Balanced')
    end

    it 'shows Balanced when position is between -20 and 20' do
      render partial: 'shared/dimension_card', locals: {
        dimension_name: 'Test',
        position: 0.0,
        intensity: 50.0,
        confidence: 50.0,
        left_pole: 'Individual Liberty',
        right_pole: 'Collective Authority'
      }

      expect(rendered).to have_content('Balanced')
    end
  end

  describe 'intensity label calculation' do
    it 'shows Strong when intensity > 75' do
      render partial: 'shared/dimension_card', locals: {
        dimension_name: 'Test',
        position: 0.0,
        intensity: 80.0,
        confidence: 50.0
      }

      expect(rendered).to have_content('Strong')
      expect(rendered).to have_content('(0.8)')
    end

    it 'shows Moderate when intensity > 50 and <= 75' do
      render partial: 'shared/dimension_card', locals: {
        dimension_name: 'Test',
        position: 0.0,
        intensity: 60.0,
        confidence: 50.0
      }

      expect(rendered).to have_content('Moderate')
      expect(rendered).to have_content('(0.6)')
    end

    it 'shows Weak when intensity <= 50' do
      render partial: 'shared/dimension_card', locals: {
        dimension_name: 'Test',
        position: 0.0,
        intensity: 40.0,
        confidence: 50.0
      }

      expect(rendered).to have_content('Weak')
      expect(rendered).to have_content('(0.4)')
    end
  end

  describe 'confidence label calculation' do
    it 'shows High when confidence > 80' do
      render partial: 'shared/dimension_card', locals: {
        dimension_name: 'Test',
        position: 0.0,
        intensity: 50.0,
        confidence: 85.0
      }

      expect(rendered).to have_content('High')
      expect(rendered).to have_content('(0.85)')
    end

    it 'shows Medium when confidence > 60 and <= 80' do
      render partial: 'shared/dimension_card', locals: {
        dimension_name: 'Test',
        position: 0.0,
        intensity: 50.0,
        confidence: 70.0
      }

      expect(rendered).to have_content('Medium')
      expect(rendered).to have_content('(0.7)')
    end

    it 'shows Low when confidence <= 60' do
      render partial: 'shared/dimension_card', locals: {
        dimension_name: 'Test',
        position: 0.0,
        intensity: 50.0,
        confidence: 50.0
      }

      expect(rendered).to have_content('Low')
      expect(rendered).to have_content('(0.5)')
    end
  end

  describe 'explanation section' do
    it 'shows explanation when provided' do
      render partial: 'shared/dimension_card', locals: {
        dimension_name: 'Test',
        position: 0.0,
        intensity: 50.0,
        confidence: 50.0,
        explanation: 'This is a test explanation.'
      }

      expect(rendered).to have_content('Why we think this:')
      expect(rendered).to have_content('This is a test explanation.')
    end

    it 'hides explanation section when not provided' do
      render partial: 'shared/dimension_card', locals: {
        dimension_name: 'Test',
        position: 0.0,
        intensity: 50.0,
        confidence: 50.0
      }

      expect(rendered).not_to have_content('Why we think this:')
    end
  end

  describe 'CSS classes' do
    it 'includes correct Tailwind CSS classes' do
      render partial: 'shared/dimension_card', locals: {
        dimension_name: 'Test',
        position: 0.0,
        intensity: 50.0,
        confidence: 50.0
      }

      expect(rendered).to have_css('.group')
      expect(rendered).to have_css('.rounded-2xl')
      expect(rendered).to have_css('.shadow-lg')
      expect(rendered).to have_css('.hover\:shadow-xl')
    end
  end
end
