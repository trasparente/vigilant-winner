###
  Forms loop. Included with {% include schema/form.html schema=page.schema %}
  @see https://tool-of-lore.github.io/silenus/docs/create-schemas/#forms
  @param {Object} gist - the new data for the gist
  @param {Requestable.callback} [cb] - the function that receives the API result
  @return {Promise} - the Promise for the http request
###
$("[data-widget=form]").each ->
  form = $ @
  commit_widget = $ "#commitModal"
  # Array of the fields label to evluate
  valuate_elements = []
  valuate_templates = []
  # Background for full pool bars
  readonly_background = form.find("[data-pool]").css 'background-color'
  # Background for empty pool bars and add blink
  main_background = $('main').css 'background-color'

  # Valuate and template manager
  valuate_manager = (e) ->
    # Match variabiles in formula: "#{to_double} * 2" -> 'to_double'
    regExp = /#{(.*?)}/g
    # Loop the variabiles
    # regExp.exec return Fulls tring matched, substring matche, index and original string
    while match = regExp.exec $(e).data 'eval'
      if valuate_elements.indexOf(match[1]) is -1
        valuate_elements.push match[1] # Store label
        # Attach evaluation on change event
        form.find("[data-path='#{match[1]}']").on 'change', (e) -> valuate e.target
        # Initial evaluation
        form.find("[data-path='#{match[1]}']").each () -> valuate @
    while match = regExp.exec $(e).data 'template'
      if valuate_templates.indexOf(match[1]) is -1
        valuate_templates.push match[1] # Store label
        # Attach evaluation on change event
        form.find("[data-path='#{match[1]}']").on 'change', (e) -> valuate e.target
        # Initial evaluation
        form.find("[data-path='#{match[1]}']").each () -> valuate @
    true

  # Function to avaluate formula and strings
  evil = (fn) ->
    new Function("return '#{fn}'")()

  # Valuate eval and template formulas
  valuate = (e) ->
    label = $(e).attr 'data-path'
    # Loop fields evaluating this field
    form.find("[data-eval*='#{label}']").each ->
      # Loop replace in the formula with field values
      formula = $(@).data('eval').replace /#{(.*?)}/g, (match, p1) ->
        return form.find("[data-path='#{p1}']").val() || 0
      # Update evaluated field and trigger change event
      $(@).val(eval formula).change()
      true
    # Loop fields templating this field
    form.find("[data-template*='#{label}']").each ->
      # Loop replace in the formula with field values
      formula = $(@).data('template').replace /#{(.*?)}/g, (match, p1) ->
        return form.find("[data-path='#{p1}']").val() || 0
      # Update evaluated field and trigger change event
      $(@).val(evil formula).change()
      true
    true

  # Loop fields to evaluate and template
  form.find("input[data-eval], input[data-template]").each -> valuate_manager @

  # Poolize function
  poolize = (e) ->
    # Get pool element, value and remove invalid class
    label = $(e).data 'pool_ref'
    pooler = form.find "[data-path='#{label}']"
    pooler.removeClass 'is-invalid'
    initial = total = Number pooler.data 'pool'
    # Set minimun for validation
    min = pooler.data('min') || 0
    # Loop fields pool-referencing the pool
    form.find("[data-pool_ref='#{label}']").each ->
      # Subtract the value
      total -= Number $(@).val()
      true
    # Update pool remaining and background
    pooler.val total
      .change()
    if total >= min
      # Background meter using linear gradient
      pooler.css 'background', "linear-gradient(to right,#{readonly_background} #{(total * 100) / initial}%,#{main_background} 0%)"
    else
      # Pool exceeded
      pooler.css 'background', 'white'
      pooler.addClass 'is-invalid'
      # pooler[0].setCustomValidity 'Pool exceeded'
    true

  # Pool on change and initial
  form.on 'change', "[data-pool_ref]", (e) -> poolize e.target
  form.find("[data-pool_ref]").each -> poolize @

  # Filtered nodes must be present as form fields (aria-label) and must be present in svg as:
  # Watched values
  # Loop elements with data-watch
  form.find("input[data-watch]").each ->
    # Watched field change event, keep this on watcher element
    watched = form.find("[data-path='#{$(@).data "watch"}']")
    watched.on 'change', (e) =>
      # Update value
      $(@).val if $(@).attr 'list'
          # Set value to option's label
          form.find("##{$(@).attr 'list'} option[value=#{e.target.value || 0}]").attr 'label'
        else e.target.value
        .change()
      true
    # Set initial value
    $(@).val if $(@).attr 'list'
        # Set value to option's label
        form.find("##{$(@).attr 'list'} option[value=#{watched.val() || 0}]").attr 'label'
      else watched.val()
      .change()
    true

  # Initialize and update range label value
  form.find("input[type=range]").each ->
    $(@).on 'change', ->
      # Get label element
      span = form.find("##{$(@).attr 'aria-describedby'} span")
      # Get decimal digits number, default 1
      resolution = Math.pow 10, $(@).data('digits') ? 1
      # Compute value
      span.html Math.round(@.value*resolution)/resolution
      true
    $(@).change()
    return

  # SVGs
  form.find("svg").each ->
    # `data-svg`, field value goes on the `href` attribute with prepended `#`
    # `href` with `#` prepended, field value goes on `svg` attribute 
    # `id`, field value goes on `svg` attribute if defined, or in inner HTML
    for el in @.querySelectorAll('[id]:not([id=""])') when form.has("[aria-label=#{el.id}]").length
      $("[aria-label=#{el.id}]").on 'change', (e) ->
        console.log $(e.target).attr('aria-label'), $(e.target).data('svg') || $(e.target).val()
      # form.on 'change', "[aria-label=#{el.id}]", =>
      #   console.log "change #{el.id}"
    true

  # Add sub-schemas
  form.on 'click', "[data-add]", (e) ->
    e.preventDefault()
    # Save data
    label = $(e.target).data 'add'
    index = Number $(e.target).data 'index'
    # Prepare regExp for data-path
    path_exp = "(data-path\=\".*)(#{label}.)(.*\")"
    path_regex = new RegExp path_exp, "g"
    # Prepare regExp for accordion_, collapse_, heading_
    accordion_regex = new RegExp "(accordion_|collapse_|heading_)([A-Za-z0-9-_]*)(\")", "g"
    # Create a card-body containing the template and replace new indexes
    html = $(e.target).siblings("template").html()
      .replace path_regex, "$1$2#{index}.$3"
      .replace accordion_regex, "$1$2_#{index}$3"
    card_body = $ '<div>',
      html: html.replace "<span></span>", "<span>#{index + 1}</span> "
      class: 'card-body added'
    # Append new card-body to the collapse
    $(e.target).closest('.items').append card_body
    # Update incremented index
    index++
    $(e.target).data 'index', index
    card_body.fadeIn "slow"
    # Update ranges
    card_body.find("input[type=range]").change()
    # Update tooltips
    card_body.find('[data-toggle*="tooltip"]').tooltip()
    # Update evals
    card_body.find("input[data-eval], input[data-template]").each -> valuate_manager @
    true

  # Remove sub-schema button handler
  form.on "click", "[data-sub]", (e) ->
    e.preventDefault()
    # Get current index and decrement it
    label = $(e.currentTarget).data "sub"
    index_element = $(e.currentTarget).parent().find("[data-add=#{label}]")
    index = Number index_element.data 'index'
    if index > 0
      index--
      index_element.data 'index', index
    # Fade out and remove the card-body
    $(e.currentTarget).parent().parent().children(".added:last-child").fadeOut "fast", () -> $(@).remove()
    true

  # Reset button handler
  form.find("[type=reset]").on "click", (e) ->
    # Clear preview <code>
    form.find("[data-widget=preview] code").html "Preview area"
    # Empty arrays
    form.find("[data-add]").each ->
      $(@).data 'index', 0
    form.find(".added").each ->
      $(@).fadeOut "fast", () -> $(@).remove()
    true

  # Validate Button handler
  form.find("[data-validate=true]").on "click", (e) ->
    e.preventDefault()
    # Destructuring Assignment
    {valid_native, valid_pools} = checkValididy()
    # Output
    valid = valid_pools && valid_native
    modal_alert "Native valid: #{valid_native}, Pools valid: #{valid_pools}", if valid then 'success' else 'danger'
    return valid
  
  ###
    Check form validation, needed in SAVE
    @return {valid_native, valid_pools} - Object with boolean validity
  ###
  checkValididy = () ->
    form.addClass 'was-validated'
    # Validate native
    valid_form = form[0].checkValidity()
    # Validate pools
    valid_pools = if form.find("[data-pool].is-invalid").length then false else true
    # Validate selects
    valid_selects = true
    form.find("select").each ->
      if $(@).attr('max') and $(@).find('option:selected').length > $(@).attr('max')
        valid_selects = false
      if $(@).attr('min') and $(@).find('option:selected').length < $(@).attr('min')
        valid_selects = false
      return
    valid_native = valid_form && valid_selects
    return {valid_native, valid_pools}

  # PREVIEW button handler
  form.find("[data-preview=true]").on "click", (e) ->
    e.preventDefault()
    object = parseForm()
    $("[data-widget=preview] code").each () ->
      if Object.keys(object).length
        $(@).html YAML.stringify object, 8, 2
      else $(@).html '<br>'
    true

  # Submit: SAVE button handler
  form.on "submit", (e) ->
    e.preventDefault()
    # Check login
    if !storage.get("token")
      modal_alert "You need to login", "danger"
      return
    # Check validity
    {valid_native, valid_pools} = checkValididy()
    if valid_native == true && valid_pools == true
      commit_widget.modal "show"
    else
      modal_alert "Native valid: #{valid_native}, Pools valid: #{valid_pools}", if (valid_pools && valid_native) then 'success' else 'danger'
    return

  # Commit widget submit
  commit_widget.find("form").on "submit", (e) -> commit e, $("#dataPath").val(), parseForm()

  ###
    Parse form values
    @return {Object} - Form values except buttons and data-exclude=true
  ###
  parseForm = () ->
    data = {}
    # Loop inputs. Exclude excluded, button, reset and submit types
    form.find(':input:not([type=submit],[type=button],[type=reset],[data-exclude])').each ->
      value = if $(@).attr("type") in ["checkbox", "radio"] then $(@).is(':checked') else $(@).val()
      if $(@).data('number') or jQuery.isNumeric(value) then value = Number value
      $(@).data('path').split('.').reduce (data, i) =>
          if form.find("[data-add=#{i}]").length
            return data[i] ?= []
          else
            return if i is $(@).attr('aria-label') then data[i] ?= value else data[i] ?= {}
        , data
      true
    # return {"#{form.data 'schema'}": data}
    return data

  # Close form-widget elements loop
  true
