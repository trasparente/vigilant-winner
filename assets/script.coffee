---
---

# Includes
{% include_relative js/storage.coffee %}
{% include_relative js/login.coffee %}
{% include_relative js/form.coffee %}

# Tooltips are opt-in
$('[data-toggle*="tooltip"]').tooltip()

console.log storage.get()

# json preview
# Preview stand alone
$('.jsonPreview').each ->
  code = $(@).find 'code'
  code.html JSON.stringify(JSON.parse(code.html()), null, 2)
  true