###
@function {modal_alert} Modal alert
@param {message} Message for the alert
@param {color} Class for text and border
@examples
  modal_alert 'Error found', 'danger'
  modal_alert 'Valid data', 'success'
###

modal_alert = (message, color = '') ->
  modal = $ '[data-widget=modal-alert]'
  # Remove old validation classes and add the new ones
  if color then modal.find('.modal-content').attr("class","modal-content").addClass "border-#{color} text-#{color}"
  modal.find('.modal-title').text message
  modal.modal 'show'
  true
