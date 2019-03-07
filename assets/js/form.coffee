$(".schema-form").each ->

  $(@).on 'click', "[data-add]", (e) ->
    e.preventDefault()
    console.log $(e.target)[0]
    true

  # Submit
  $(@).on "submit", (e) ->
    e.preventDefault()
    $(@).find(':input:not([type=submit],[type=button])').each ->
      console.log $(@).val(), $(@).attr('id')
      true
    true

  true