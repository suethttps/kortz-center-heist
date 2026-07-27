import { Controller } from "@hotwired/stimulus"

// =============================================================================
// BagController
// -----------------------------------------------------------------------------
// Secondaries (bolsa 100%) + Primary do carrossel + bônus opcionais:
//   Buyer’s Request  → $50k Easy / $100k Hard
//   Elite Challenge  → $50k Easy / $100k Hard
// A dificuldade vem do toggle Easy/Hard do Primary Target.
// =============================================================================
export default class extends Controller {
  static targets = [
    "item", "fill", "used", "total", "hint", "count",
    "primaryTotal", "primaryName", "grandTotal",
    "buyerBonus", "eliteBonus", "buyerLabel", "eliteLabel"
  ]
  static values = {
    capacity: { type: Number, default: 100 },
    bonusEasy: { type: Number, default: 50_000 },
    bonusHard: { type: Number, default: 100_000 }
  }

  primaryAmount = 0
  primaryLabel = "—"
  difficulty = "easy" // espelha o carrossel
  buyerOn = false
  eliteOn = false

  connect() {
    this._onPrimary = (event) => {
      this.primaryAmount = Number(event.detail?.amount) || 0
      this.primaryLabel = event.detail?.name || "—"
      if (event.detail?.difficulty) this.difficulty = event.detail.difficulty
      this.refresh()
    }
    document.addEventListener("kortz:primary-payout", this._onPrimary)
    document.dispatchEvent(new CustomEvent("kortz:request-primary-payout"))
    this.refresh()
  }

  disconnect() {
    document.removeEventListener("kortz:primary-payout", this._onPrimary)
  }

  // Valor do bônus conforme Easy/Hard do primary
  bonusAmount() {
    return this.difficulty === "hard" ? this.bonusHardValue : this.bonusEasyValue
  }

  toggleBuyer() {
    this.buyerOn = !this.buyerOn
    this.refresh()
  }

  toggleElite() {
    this.eliteOn = !this.eliteOn
    this.refresh()
  }

  toggle(event) {
    const item = event.currentTarget
    const weight = Number(item.dataset.bagWeightValue) || 0
    const selected = item.classList.contains("is-selected")

    if (selected) {
      item.classList.remove("is-selected")
      item.setAttribute("aria-pressed", "false")
    } else {
      if (this.usedWeight() + weight > this.capacityValue) {
        this.flashHint("Won't fit in the bag (would go over 100%).")
        return
      }
      item.classList.add("is-selected")
      item.setAttribute("aria-pressed", "true")
    }

    this.refresh()
  }

  clear() {
    this.itemTargets.forEach((item) => {
      item.classList.remove("is-selected")
      item.setAttribute("aria-pressed", "false")
    })
    this.buyerOn = false
    this.eliteOn = false
    this.refresh()
  }

  usedWeight() {
    return this.selectedItems().reduce((sum, item) => {
      return sum + (Number(item.dataset.bagWeightValue) || 0)
    }, 0)
  }

  secondaryValue() {
    return this.selectedItems().reduce((sum, item) => {
      return sum + (Number(item.dataset.bagPriceValue) || 0)
    }, 0)
  }

  selectedItems() {
    return this.itemTargets.filter((item) => item.classList.contains("is-selected"))
  }

  refresh() {
    const used = this.usedWeight()
    const secondary = this.secondaryValue()
    const primary = this.primaryAmount
    const bonus = this.bonusAmount()
    const buyer = this.buyerOn ? bonus : 0
    const elite = this.eliteOn ? bonus : 0
    const grand = primary + secondary + buyer + elite
    const count = this.selectedItems().length
    const pct = Math.min(100, Math.round((used / this.capacityValue) * 100))
    const diffLabel = this.difficulty === "hard" ? "Hard" : "Easy"

    if (this.hasFillTarget) {
      this.fillTarget.style.width = `${pct}%`
      this.fillTarget.classList.toggle("is-full", used >= this.capacityValue)
    }

    if (this.hasUsedTarget) {
      this.usedTarget.textContent = `${used}% / ${this.capacityValue}%`
    }

    if (this.hasCountTarget) {
      this.countTarget.textContent = String(count)
    }

    if (this.hasPrimaryNameTarget) {
      this.primaryNameTarget.textContent = this.primaryLabel
    }

    if (this.hasPrimaryTotalTarget) {
      this.primaryTotalTarget.textContent = this.formatMoney(primary)
    }

    if (this.hasTotalTarget) {
      this.totalTarget.textContent = this.formatMoney(secondary)
    }

    // Labels dos bônus acompanham a dificuldade do primary
    if (this.hasBuyerLabelTarget) {
      this.buyerLabelTarget.textContent = `Buyer’s Request (${diffLabel})`
    }
    if (this.hasEliteLabelTarget) {
      this.eliteLabelTarget.textContent = `Elite Challenge (${diffLabel})`
    }
    if (this.hasBuyerBonusTarget) {
      this.buyerBonusTarget.textContent = this.formatMoney(bonus)
      this.buyerBonusTarget.closest(".bag-bonus")?.classList.toggle("is-on", this.buyerOn)
    }
    if (this.hasEliteBonusTarget) {
      this.eliteBonusTarget.textContent = this.formatMoney(bonus)
      this.eliteBonusTarget.closest(".bag-bonus")?.classList.toggle("is-on", this.eliteOn)
    }

    // aria-pressed nos botões de bônus
    this.element.querySelectorAll("[data-bonus]").forEach((btn) => {
      const kind = btn.dataset.bonus
      const on = kind === "buyer" ? this.buyerOn : this.eliteOn
      btn.classList.toggle("is-on", on)
      btn.setAttribute("aria-pressed", on ? "true" : "false")
    })

    if (this.hasGrandTotalTarget) {
      this.grandTotalTarget.textContent = this.formatMoney(grand)
    }

    if (this.hasHintTarget && !this.hintTarget.classList.contains("is-warn")) {
      if (used === 0 && !this.buyerOn && !this.eliteOn) {
        this.hintTarget.textContent = "Pick secondaries and toggle bonuses if you complete them."
      } else if (used >= this.capacityValue) {
        this.hintTarget.textContent = "Bag full · bonuses follow Easy/Hard on the primary."
      } else {
        this.hintTarget.textContent = `~${this.capacityValue - used}% left · bonus = ${this.formatMoney(bonus)} (${diffLabel})`
      }
    }

    this.itemTargets.forEach((item) => {
      const weight = Number(item.dataset.bagWeightValue) || 0
      const selected = item.classList.contains("is-selected")
      const wouldOverflow = !selected && used + weight > this.capacityValue
      item.classList.toggle("is-disabled", wouldOverflow)
      item.disabled = wouldOverflow
    })
  }

  flashHint(message) {
    if (!this.hasHintTarget) return
    this.hintTarget.textContent = message
    this.hintTarget.classList.add("is-warn")
    clearTimeout(this._hintTimer)
    this._hintTimer = setTimeout(() => {
      this.hintTarget.classList.remove("is-warn")
      this.refresh()
    }, 1400)
  }

  formatMoney(amount) {
    return "GTA$" + Number(amount || 0).toLocaleString("en-US")
  }
}
