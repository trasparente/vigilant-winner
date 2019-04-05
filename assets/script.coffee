---
---

# Includes
{% include scripts/storage.coffee %}
{% include scripts/login.coffee %}
{% include scripts/modal_alert.coffee %}
{% include scripts/commit.coffee %}
{% include scripts/form.coffee %}

# Tooltips are opt-in
$('[data-toggle*="tooltip"]').tooltip()

console.log storage.get()

# json preview stringify format with tabs
$('.jsonPreview.collapse').each ->
  code = $(@).find 'code'
  code.html JSON.stringify(JSON.parse(code.html()), null, 2)
  true