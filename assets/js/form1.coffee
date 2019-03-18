$(".schema-form").each ->
  # Add to list
  $(@).on 'click', "[data-add]", (e) ->
    e.preventDefault()
    card = $(e.target).parents(".card").eq 0
    template = card.find("template").html()
    card.children('.card-body').append template
    true

  # Remove from list
  $(@).on "click", "[aria-label='Remove']", (e) ->
    e.preventDefault()
    dismissible = $(e.target).parents(".#{$(e.target).data("dismiss")}").eq 0
    $(dismissible).remove()
    true

  # Submit
  $(@).on "submit", (e) ->
    obj = {}
    counter = {}
    e.preventDefault()
    $(@).find(":input:not([type=submit],[type=button])").each ->
      value = switch $(@).attr("type")
        when "text" then $(@).val()
        when "checkbox" or "radio" then $(@).is(':checked')
        when "number" then Number $(@).val()
      loop_array = $(@).data('path').split('.')
      loop_array.reduce (obj, p, i) =>
          if loop_array[i+1] is "0"
            return obj[p] ?= []
          else
            return if i is loop_array.length-1 then obj[p] ?= value else obj[p] ?= {}
        , obj
      true
    console.log JSON.stringify(obj,null,2)
    true

  true