import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="tabs"
export default class extends Controller {
  static targets = ["tab", "panel"]

  connect() {
    // Show the first tab by default
    this.showTab("overview")
  }

  switch(event) {
    const tabName = event.currentTarget.dataset.tabName
    this.showTab(tabName)
  }

  showTab(tabName) {
    // Update tab buttons
    this.tabTargets.forEach(tab => {
      const isActive = tab.dataset.tabName === tabName
      
      if (isActive) {
        tab.classList.remove("text-gray-600", "border-transparent")
        tab.classList.add("text-blue-600", "border-blue-600")
      } else {
        tab.classList.remove("text-blue-600", "border-blue-600")
        tab.classList.add("text-gray-600", "border-transparent")
      }
    })

    // Update panels
    this.panelTargets.forEach(panel => {
      const isActive = panel.dataset.panelName === tabName
      
      if (isActive) {
        panel.classList.remove("hidden")
      } else {
        panel.classList.add("hidden")
      }
    })
  }
}

