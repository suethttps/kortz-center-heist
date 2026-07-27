import { Controller } from "@hotwired/stimulus"

// =============================================================================
// CarouselController
// -----------------------------------------------------------------------------
// - Troca slides dos Main Targets
// - Toggle Easy/Hard + First/Repeat + Alarm atualiza o preço "hero"
// =============================================================================
export default class extends Controller {
  static targets = ["slide", "dot", "counter", "heroPrice", "modeLabel"]

  index = 0
  difficulty = "easy" // easy | hard
  run = "first"       // first | repeat
  alarm = false       // false = no alarm

  connect() {
    // Se a bolsa conectar depois, ela pede o valor atual
    this._onRequest = () => this.refreshPrice()
    document.addEventListener("kortz:request-primary-payout", this._onRequest)

    this.show(this.index)
    this.refreshPrice()
  }

  disconnect() {
    document.removeEventListener("kortz:request-primary-payout", this._onRequest)
  }

  prev() {
    this.show(this.index - 1)
  }

  next() {
    this.show(this.index + 1)
  }

  goTo(event) {
    const el = event.currentTarget
    // Select do jump OU botão/dot com data-carousel-index
    const i = el.tagName === "SELECT"
      ? Number(el.value)
      : Number(el.dataset.carouselIndex)
    if (!Number.isNaN(i)) this.show(i)
  }

  // Troca Easy ↔ Hard
  setDifficulty(event) {
    this.difficulty = event.currentTarget.dataset.difficulty
    this.syncToggleButtons("difficulty")
    this.refreshPrice()
  }

  // Troca First weekly ↔ Repeat
  setRun(event) {
    this.run = event.currentTarget.dataset.run
    this.syncToggleButtons("run")
    this.refreshPrice()
  }

  // Liga/desliga alarme
  setAlarm(event) {
    this.alarm = event.currentTarget.dataset.alarm === "true"
    this.syncToggleButtons("alarm")
    this.refreshPrice()
  }

  show(rawIndex) {
    const total = this.slideTargets.length
    if (total === 0) return

    this.index = ((rawIndex % total) + total) % total

    this.slideTargets.forEach((slide, i) => {
      const active = i === this.index
      slide.hidden = !active
      slide.classList.toggle("is-active", active)
    })

    if (this.hasDotTarget) {
      this.dotTargets.forEach((dot, i) => {
        dot.classList.toggle("is-active", i === this.index)
        dot.setAttribute("aria-current", i === this.index ? "true" : "false")
      })
    }

    if (this.hasCounterTarget) {
      this.counterTarget.textContent = `${this.index + 1} / ${total}`
    }

    // Mantém o <select> sincronizado com as setas
    const select = this.element.querySelector(".carousel__jump select")
    if (select) select.value = String(this.index)

    this.refreshPrice()
  }

  // Atualiza o preço grande do slide ativo
  refreshPrice() {
    const slide = this.slideTargets[this.index]
    if (!slide) return

    const key = [
      this.difficulty,
      this.run,
      this.alarm ? "alarm" : "no_alarm"
    ].join("_")

    // data-payout-easy-first-no-alarm → dataset.payoutEasyFirstNoAlarm
    const datasetKey = "payout" + key
      .split("_")
      .map((part) => part.charAt(0).toUpperCase() + part.slice(1))
      .join("")

    const raw = slide.dataset[datasetKey]
    const amount = raw ? Number(raw) : null

    if (this.hasHeroPriceTarget) {
      // Atualiza só o hero do slide ativo (há um target por slide)
      const heroes = this.heroPriceTargets
      heroes.forEach((el) => {
        const inActive = slide.contains(el)
        if (inActive) el.textContent = this.formatMoney(amount)
      })
    }

    if (this.hasModeLabelTarget) {
      const labels = this.modeLabelTargets
      const text = this.modeText()
      labels.forEach((el) => {
        if (slide.contains(el)) el.textContent = text
      })
    }

    // Destaca a célula correspondente na tabela do slide
    slide.querySelectorAll("[data-payout-cell]").forEach((cell) => {
      cell.classList.toggle("is-highlight", cell.dataset.payoutCell === key)
    })

    // Avisa a bolsa (bag_controller) pro total = primary + secondaries
    this.broadcastPayout(amount, slide)
  }

  // Evento global: bag_controller escuta e soma com a bolsa + bônus
  broadcastPayout(amount, slide) {
    const name = slide.querySelector(".polaroid__caption")?.textContent?.trim() || ""
    document.dispatchEvent(
      new CustomEvent("kortz:primary-payout", {
        detail: {
          amount: Number(amount) || 0,
          name,
          mode: this.modeText(),
          difficulty: this.difficulty // "easy" | "hard" — define $50k / $100k dos bônus
        }
      })
    )
  }

  modeText() {
    const diff = this.difficulty === "hard" ? "Hard" : "Easy"
    const run = this.run === "first" ? "1st weekly" : "Repeat"
    const alarm = this.alarm ? "Alarm" : "No alarm"
    return `${diff} · ${run} · ${alarm}`
  }

  syncToggleButtons(group) {
    this.element.querySelectorAll(`[data-toggle-group="${group}"]`).forEach((btn) => {
      let active = false
      if (group === "difficulty") active = btn.dataset.difficulty === this.difficulty
      if (group === "run") active = btn.dataset.run === this.run
      if (group === "alarm") active = (btn.dataset.alarm === "true") === this.alarm
      btn.classList.toggle("is-active", active)
    })
  }

  formatMoney(amount) {
    if (amount == null || Number.isNaN(amount)) return "GTA$—"
    return "GTA$" + amount.toLocaleString("en-US")
  }
}
