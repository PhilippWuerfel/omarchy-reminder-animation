function display(items, pin, now) {
    return pin || items.find(r => r.at > now) || null
}
function created(r) {
    // omarchy-reminder names its units omarchy-reminder-<minutes>m-<set_at>.
    const match = /-(\d+)$/.exec(r.unit || '')
    return match ? Number(match[1]) : r.at - (r.minutes || 0) * 60
}
function reconcile(items, pin, now) {
    const running = items.filter(r => r.at > now)
    if (pin && pin.at <= now) {
        // A reminder set after the expiry acknowledges it and becomes the new
        // watch. Otherwise keep the completed watch until the widget is
        // clicked, even after the native reminder has left the provider's list.
        const fresh = running.filter(r => created(r) >= pin.at)
        return fresh.length ? fresh.reduce((a, b) => created(b) > created(a) ? b : a) : pin
    }
    const existing = pin && items.find(r => r.unit === pin.unit)
    if (existing) return existing
    // Nothing watched: follow the reminder that was set first.
    return running.length ? running.reduce((a, b) =>
        created(b) < created(a) || (created(b) === created(a) && b.at < a.at) ? b : a) : null
}
