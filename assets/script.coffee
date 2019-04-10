---
---

# Includes
{% include scripts/storage.coffee %}
{% include scripts/login.coffee %}
{% include scripts/modal_alert.coffee %}
{% include scripts/commit.coffee %}
{% include scripts/form.coffee %}
{% include scripts/version.coffee %}

# Tooltips are opt-in
$('[data-toggle*="tooltip"]').tooltip()

# Init or get storage
console.log storage.get()

# version update handler
$("[data-click='version_update']").on "click", (e) ->
  e.preventDefault()
  version.update e
  return

# json preview stringify format with tabs
$('.jsonPreview.collapse').each ->
  code = $(@).find 'code'
  code.html JSON.stringify(JSON.parse(code.html()), null, 2)
  true