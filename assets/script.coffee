---
---

# Includes
{% include_relative js/storage.coffee %}
{% include_relative js/login.coffee %}
{% include_relative js/form1.coffee %}

# Tooltips are opt-in
$('[data-toggle*="tooltip"]').tooltip()

console.log storage.get()

# json preview stringify format with tabs
$('.jsonPreview.collapse').each ->
  code = $(@).find 'code'
  code.html JSON.stringify(JSON.parse(code.html()), null, 2)
  true