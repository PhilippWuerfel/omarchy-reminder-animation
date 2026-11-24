function display(items, pin, now) {
    return pin || items.find(r => r.at > now) || null
}
function reconcile(items, pin, now) {
    // Keep a completed watch until the widget acknowledges it, even after
    // the native reminder has disappeared from the provider's list.
    if (pin && pin.at <= now) return pin
    const existing = pin && items.find(r => r.unit === pin.unit)
    if (existing) return existing
    return items.length === 1 && items[0].at > now ? items[0] : null
}
