function display(items, pin, now) {
    return pin || items.find(r => r.at > now) || null
}
function reconcile(items, pin, now) {
    if (!pin || pin.at <= now) return pin
    return items.find(r => r.unit === pin.unit) || null
}
