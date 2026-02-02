require 'rails_helper'

RSpec.describe 'shared/_gradient_header.html.erb', type: :view do
  describe 'rendering with required parameters' do
    it 'renders the header with title' do
      render partial: 'shared/gradient_header', locals: {
        title: 'Your Value Portrait'
      }

      expect(rendered).to have_css('h1', text: 'Your Value Portrait')
      expect(rendered).to have_css('.bg-gradient-to-r')
      expect(rendered).to have_css('.bg-clip-text')
    end
  end

  describe 'optional subtitle' do
    it 'shows subtitle when provided' do
      render partial: 'shared/gradient_header', locals: {
        title: 'Dashboard',
        subtitle: 'See how political parties align with your values'
      }

      expect(rendered).to have_content('Dashboard')
      expect(rendered).to have_content('See how political parties align with your values')
    end

    it 'hides subtitle when not provided' do
      render partial: 'shared/gradient_header', locals: {
        title: 'Dashboard'
      }

      expect(rendered).to have_content('Dashboard')
      expect(rendered).not_to have_css('p.text-gray-600')
    end
  end

  describe 'gradient colors' do
    it 'uses default gradient colors when not specified' do
      render partial: 'shared/gradient_header', locals: {
        title: 'Test'
      }

      expect(rendered).to have_css('.from-blue-600')
      expect(rendered).to have_css('.to-purple-600')
    end

    it 'uses custom gradient colors when specified' do
      render partial: 'shared/gradient_header', locals: {
        title: 'Test',
        gradient_from: 'green-500',
        gradient_to: 'yellow-500'
      }

      expect(rendered).to have_css('.from-green-500')
      expect(rendered).to have_css('.to-yellow-500')
    end
  end

  describe 'badge' do
    it 'shows badge when badge_text is provided' do
      render partial: 'shared/gradient_header', locals: {
        title: 'Test',
        badge_text: '✓ Assessment Complete'
      }

      expect(rendered).to have_content('✓ Assessment Complete')
      expect(rendered).to have_css('.bg-blue-100')
      expect(rendered).to have_css('.text-blue-700')
    end

    it 'uses custom badge color when specified' do
      render partial: 'shared/gradient_header', locals: {
        title: 'Test',
        badge_text: 'New',
        badge_color: 'green'
      }

      expect(rendered).to have_content('New')
      expect(rendered).to have_css('.bg-green-100')
      expect(rendered).to have_css('.text-green-700')
    end

    it 'hides badge when badge_text is not provided' do
      render partial: 'shared/gradient_header', locals: {
        title: 'Test'
      }

      expect(rendered).not_to have_css('.rounded-full.text-sm.font-semibold')
    end
  end

  describe 'centering' do
    it 'centers content when center is true' do
      render partial: 'shared/gradient_header', locals: {
        title: 'Test',
        center: true
      }

      expect(rendered).to have_css('.text-center')
    end

    it 'does not center content by default' do
      render partial: 'shared/gradient_header', locals: {
        title: 'Test'
      }

      expect(rendered).not_to have_css('.text-center')
    end
  end

  describe 'text size' do
    it 'uses default text size when not specified' do
      render partial: 'shared/gradient_header', locals: {
        title: 'Test'
      }

      expect(rendered).to have_css('.text-3xl')
    end

    it 'uses custom text size when specified' do
      render partial: 'shared/gradient_header', locals: {
        title: 'Test',
        text_size: '2xl sm:text-3xl'
      }

      expect(rendered).to have_css('.text-2xl')
    end
  end

  describe 'HTML in title' do
    it 'renders HTML in title when provided' do
      render partial: 'shared/gradient_header', locals: {
        title: 'Your <span class="bg-gradient-to-r from-blue-600 to-purple-600 bg-clip-text text-transparent">Value Portrait</span>'
      }

      expect(rendered).to have_css('span.bg-gradient-to-r')
      expect(rendered).to have_content('Your')
      expect(rendered).to have_content('Value Portrait')
    end
  end

  describe 'CSS classes' do
    it 'includes correct Tailwind CSS classes' do
      render partial: 'shared/gradient_header', locals: {
        title: 'Test'
      }

      expect(rendered).to have_css('.mb-8')
      expect(rendered).to have_css('.font-bold')
      expect(rendered).to have_css('.text-gray-900')
    end
  end
end

