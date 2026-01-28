import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="radar-chart"
export default class extends Controller {
  static targets = ["svg", "tooltip"]
  static values = {
    dimensions: Array,
    userValues: Array,
    actorValues: Array,
    actorName: String,
    showComparison: { type: Boolean, default: false }
  }

  connect() {
    this.renderChart()
    this.setupEventListeners()
  }

  renderChart() {
    const svg = this.svgTarget
    const width = 400
    const height = 400
    const centerX = width / 2
    const centerY = height / 2
    const maxRadius = 150
    const numAxes = this.dimensionsValue.length

    // Clear existing content
    svg.innerHTML = ''
    svg.setAttribute('viewBox', `0 0 ${width} ${height}`)

    // Create background circles (grid)
    this.createGridCircles(svg, centerX, centerY, maxRadius)

    // Create axes with labels
    this.createAxes(svg, centerX, centerY, maxRadius, numAxes)

    // Create data polygons
    if (this.showComparisonValue && this.actorValuesValue.length > 0) {
      // Show both user and actor
      this.createDataPolygon(svg, this.actorValuesValue, centerX, centerY, maxRadius, numAxes, '#EF4444', 'rgba(239, 68, 68, 0.15)')
      this.createDataPolygon(svg, this.userValuesValue, centerX, centerY, maxRadius, numAxes, '#3B82F6', 'rgba(59, 130, 246, 0.2)')
    } else {
      // Show only user
      this.createDataPolygon(svg, this.userValuesValue, centerX, centerY, maxRadius, numAxes, '#3B82F6', 'rgba(59, 130, 246, 0.3)')
    }

    // Create interactive data points
    this.createDataPoints(svg, this.userValuesValue, centerX, centerY, maxRadius, numAxes, '#3B82F6', 'user')
    if (this.showComparisonValue && this.actorValuesValue.length > 0) {
      this.createDataPoints(svg, this.actorValuesValue, centerX, centerY, maxRadius, numAxes, '#EF4444', 'actor')
    }
  }

  createGridCircles(svg, cx, cy, maxRadius) {
    const circles = [0.33, 0.66, 1.0]
    circles.forEach(ratio => {
      const circle = document.createElementNS('http://www.w3.org/2000/svg', 'circle')
      circle.setAttribute('cx', cx)
      circle.setAttribute('cy', cy)
      circle.setAttribute('r', maxRadius * ratio)
      circle.setAttribute('fill', 'none')
      circle.setAttribute('stroke', ratio === 1.0 ? '#D1D5DB' : '#E5E7EB')
      circle.setAttribute('stroke-width', ratio === 1.0 ? '2' : '1')
      svg.appendChild(circle)
    })
  }

  createAxes(svg, cx, cy, maxRadius, numAxes) {
    for (let i = 0; i < numAxes; i++) {
      const angle = (i * (360 / numAxes) - 90) * Math.PI / 180
      const x = cx + maxRadius * Math.cos(angle)
      const y = cy + maxRadius * Math.sin(angle)

      // Axis line
      const line = document.createElementNS('http://www.w3.org/2000/svg', 'line')
      line.setAttribute('x1', cx)
      line.setAttribute('y1', cy)
      line.setAttribute('x2', x)
      line.setAttribute('y2', y)
      line.setAttribute('stroke', '#D1D5DB')
      line.setAttribute('stroke-width', '1.5')
      svg.appendChild(line)

      // Axis label
      const labelDistance = maxRadius + 30
      const labelX = cx + labelDistance * Math.cos(angle)
      const labelY = cy + labelDistance * Math.sin(angle)

      const text = document.createElementNS('http://www.w3.org/2000/svg', 'text')
      text.setAttribute('x', labelX)
      text.setAttribute('y', labelY)
      text.setAttribute('text-anchor', 'middle')
      text.setAttribute('dominant-baseline', 'middle')
      text.setAttribute('class', 'text-xs font-semibold fill-gray-700')
      text.setAttribute('style', 'font-size: 11px;')

      // Split long dimension names into multiple lines
      const dimensionName = this.dimensionsValue[i]
      const words = dimensionName.split(' ')
      if (words.length > 2) {
        const tspan1 = document.createElementNS('http://www.w3.org/2000/svg', 'tspan')
        tspan1.setAttribute('x', labelX)
        tspan1.setAttribute('dy', '-0.6em')
        tspan1.textContent = words.slice(0, Math.ceil(words.length / 2)).join(' ')
        text.appendChild(tspan1)

        const tspan2 = document.createElementNS('http://www.w3.org/2000/svg', 'tspan')
        tspan2.setAttribute('x', labelX)
        tspan2.setAttribute('dy', '1.2em')
        tspan2.textContent = words.slice(Math.ceil(words.length / 2)).join(' ')
        text.appendChild(tspan2)
      } else {
        text.textContent = dimensionName
      }

      svg.appendChild(text)
    }
  }

  createDataPolygon(svg, values, cx, cy, maxRadius, numAxes, strokeColor, fillColor) {
    const points = values.map((value, i) => {
      const angle = (i * (360 / numAxes) - 90) * Math.PI / 180
      // Normalize value from -100/100 to 0/100 range, then to radius
      const normalizedValue = Math.abs(value) / 100
      const radius = normalizedValue * maxRadius
      const x = cx + radius * Math.cos(angle)
      const y = cy + radius * Math.sin(angle)
      return `${x},${y}`
    }).join(' ')

    const polygon = document.createElementNS('http://www.w3.org/2000/svg', 'polygon')
    polygon.setAttribute('points', points)
    polygon.setAttribute('fill', fillColor)
    polygon.setAttribute('stroke', strokeColor)
    polygon.setAttribute('stroke-width', '2.5')
    polygon.setAttribute('stroke-linejoin', 'round')
    svg.appendChild(polygon)
  }

  createDataPoints(svg, values, cx, cy, maxRadius, numAxes, color, type) {
    values.forEach((value, i) => {
      const angle = (i * (360 / numAxes) - 90) * Math.PI / 180
      const normalizedValue = Math.abs(value) / 100
      const radius = normalizedValue * maxRadius
      const x = cx + radius * Math.cos(angle)
      const y = cy + radius * Math.sin(angle)

      const circle = document.createElementNS('http://www.w3.org/2000/svg', 'circle')
      circle.setAttribute('cx', x)
      circle.setAttribute('cy', y)
      circle.setAttribute('r', '5')
      circle.setAttribute('fill', color)
      circle.setAttribute('stroke', 'white')
      circle.setAttribute('stroke-width', '2')
      circle.setAttribute('class', 'cursor-pointer transition-all duration-200 hover:r-7')
      circle.setAttribute('data-dimension', this.dimensionsValue[i])
      circle.setAttribute('data-value', value)
      circle.setAttribute('data-type', type)
      circle.setAttribute('data-index', i)

      // Add hover events
      circle.addEventListener('mouseenter', (e) => this.showTooltip(e))
      circle.addEventListener('mouseleave', () => this.hideTooltip())

      svg.appendChild(circle)
    })
  }

  setupEventListeners() {
    // Additional setup if needed
  }

  showTooltip(event) {
    const dimension = event.target.getAttribute('data-dimension')
    const value = event.target.getAttribute('data-value')
    const type = event.target.getAttribute('data-type')

    if (!this.hasTooltipTarget) return

    const label = type === 'user' ? 'Your Value' : this.actorNameValue || 'Actor'
    this.tooltipTarget.innerHTML = `
      <div class="bg-gray-900 text-white px-3 py-2 rounded-lg shadow-lg text-sm">
        <div class="font-semibold mb-1">${dimension}</div>
        <div class="text-gray-300">${label}: <span class="font-bold">${value}</span></div>
      </div>
    `
    this.tooltipTarget.classList.remove('hidden')

    // Position tooltip near cursor
    const rect = this.svgTarget.getBoundingClientRect()
    const x = event.clientX - rect.left
    const y = event.clientY - rect.top

    this.tooltipTarget.style.position = 'absolute'
    this.tooltipTarget.style.left = `${x + 10}px`
    this.tooltipTarget.style.top = `${y - 10}px`
    this.tooltipTarget.style.pointerEvents = 'none'
  }

  hideTooltip() {
    if (this.hasTooltipTarget) {
      this.tooltipTarget.classList.add('hidden')
    }
  }
}
