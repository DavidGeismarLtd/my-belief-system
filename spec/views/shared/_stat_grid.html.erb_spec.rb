require 'rails_helper'

RSpec.describe 'shared/_stat_grid.html.erb', type: :view do
  describe 'rendering with stats hash' do
    it 'renders all stats from the hash' do
      stats = {
        lean: { label: 'Lean', value: 'Individual', color: 'purple' },
        intensity: { label: 'Intensity', value: 'Strong (0.75)', color: 'blue', icon: '💪' },
        confidence: { label: 'Confidence', value: 'High (0.8)', color: 'green', icon: '✓' }
      }

      render partial: 'shared/stat_grid', locals: { stats: stats }

      expect(rendered).to have_content('Lean')
      expect(rendered).to have_content('Individual')
      expect(rendered).to have_content('Intensity')
      expect(rendered).to have_content('Strong (0.75)')
      expect(rendered).to have_content('Confidence')
      expect(rendered).to have_content('High (0.8)')
    end

    it 'renders with minimal stats' do
      stats = {
        value1: { value: 'Test Value' }
      }

      render partial: 'shared/stat_grid', locals: { stats: stats }

      expect(rendered).to have_content('Value1')
      expect(rendered).to have_content('Test Value')
    end
  end

  describe 'column calculation' do
    it 'uses 2 columns for 2 stats' do
      stats = {
        stat1: { label: 'Stat 1', value: 'Value 1', color: 'blue' },
        stat2: { label: 'Stat 2', value: 'Value 2', color: 'green' }
      }

      render partial: 'shared/stat_grid', locals: { stats: stats }

      expect(rendered).to have_css('.sm\:grid-cols-2')
    end

    it 'uses 3 columns for 3 stats' do
      stats = {
        stat1: { label: 'Stat 1', value: 'Value 1', color: 'blue' },
        stat2: { label: 'Stat 2', value: 'Value 2', color: 'green' },
        stat3: { label: 'Stat 3', value: 'Value 3', color: 'purple' }
      }

      render partial: 'shared/stat_grid', locals: { stats: stats }

      expect(rendered).to have_css('.sm\:grid-cols-3')
    end

    it 'uses custom column count when specified' do
      stats = {
        stat1: { label: 'Stat 1', value: 'Value 1', color: 'blue' }
      }

      render partial: 'shared/stat_grid', locals: { stats: stats, columns: 2 }

      expect(rendered).to have_css('.sm\:grid-cols-2')
    end
  end

  describe 'color application' do
    it 'applies correct color classes' do
      stats = {
        test: { label: 'Test', value: 'Value', color: 'purple' }
      }

      render partial: 'shared/stat_grid', locals: { stats: stats }

      expect(rendered).to have_css('.from-purple-50')
      expect(rendered).to have_css('.to-purple-100')
      expect(rendered).to have_css('.border-purple-200')
      expect(rendered).to have_css('.text-purple-900')
      expect(rendered).to have_css('.text-purple-700')
    end

    it 'uses gray as default color when not specified' do
      stats = {
        test: { label: 'Test', value: 'Value' }
      }

      render partial: 'shared/stat_grid', locals: { stats: stats }

      expect(rendered).to have_css('.from-gray-50')
      expect(rendered).to have_css('.to-gray-100')
    end
  end

  describe 'icon display' do
    it 'shows icon when provided' do
      stats = {
        test: { label: 'Test', value: 'Value', color: 'blue', icon: '💪' }
      }

      render partial: 'shared/stat_grid', locals: { stats: stats }

      expect(rendered).to have_content('💪')
    end

    it 'hides icon when not provided' do
      stats = {
        test: { label: 'Test', value: 'Value', color: 'blue' }
      }

      render partial: 'shared/stat_grid', locals: { stats: stats }

      expect(rendered).to have_content('Test')
      expect(rendered).to have_content('Value')
    end
  end

  describe 'compact mode' do
    it 'applies compact layout when compact is true' do
      stats = {
        test: { label: 'Test', value: 'Value', color: 'blue' }
      }

      render partial: 'shared/stat_grid', locals: { stats: stats, compact: true }

      expect(rendered).to have_content('Test')
      expect(rendered).to have_content('Value')
    end

    it 'uses normal layout by default' do
      stats = {
        test: { label: 'Test', value: 'Value', color: 'blue' }
      }

      render partial: 'shared/stat_grid', locals: { stats: stats }

      expect(rendered).to have_css('.text-center')
    end
  end

  describe 'CSS classes' do
    it 'includes correct Tailwind CSS classes' do
      stats = {
        test: { label: 'Test', value: 'Value', color: 'blue' }
      }

      render partial: 'shared/stat_grid', locals: { stats: stats }

      expect(rendered).to have_css('.grid')
      expect(rendered).to have_css('.gap-4')
      expect(rendered).to have_css('.rounded-xl')
      expect(rendered).to have_css('.bg-gradient-to-br')
    end
  end
end
