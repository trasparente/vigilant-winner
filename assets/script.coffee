---
---

# Includes
{% include_relative js/storage.coffee %}
{% include_relative js/login.coffee %}

# Tooltips are opt-in
$('[data-toggle*="tooltip"]').tooltip()

console.log storage.get()