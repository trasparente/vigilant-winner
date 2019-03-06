###
  Need:
  - Bootstrap modal id="loginModal"
  - Form id="loginForm" with a type="submit" <button> and a div.invalid-feedback
  - Login link with data-toggle="modal" and data-target="#loginModal"
  - Token input id="personalToken"
###
$("#loginForm").on "submit", (e) ->
  e.preventDefault()
  $("#loginForm button[type='submit']").prop "disabled", true
  $("#personalToken").removeClass "is-invalid"
  $.ajax "{{ site.github.api_url }}/user",
    method: "GET"
    headers: {"Authorization": "token #{$('#personalToken').val()}"}
    success: login_success
    error: login_error
  true
login_success = (data, status) ->
  $("#loginModal").modal "hide"
  storage.set "token", $("#personalToken").val()
    .set "user", data.login
    .set "logged", new Date()
  $("[data-target='#loginModal']").text "Logout"
    .attr "data-original-title", "Logged as #{data.login}"
    .attr "data-toggle", "tooltip"
    .tooltip "show"
    .off "click"
    .on "click", login_logout
  setTimeout ->
    $("[data-target='#loginModal']").tooltip "hide"
    $("#personalToken").val ""
  , 3000
  true
login_error = (request, status, error) ->
  $("#loginForm .invalid-feedback").html "#{status}: #{error}"
  $("#personalToken").addClass("is-invalid")
  $("#loginForm button[type='submit']").prop "disabled", false
  true
login_logout = (e) ->
  e.preventDefault()
  storage.clear()
  $ e.target
    .text "Login"
    .attr "data-original-title", "Logged Out"
    .tooltip "show"
    .off "click"
  setTimeout ->
    $(e.target).attr "data-toggle", "modal"
      .tooltip "dispose"
  , 3000
  true
# Init: check logged
$("[data-target='#loginModal']").each ->
  if storage.get('token') and $(@).text() == "Login"
    $(@).text 'Logout'
      .attr 'title', "Logged as #{storage.get('user')}"
      .attr 'data-toggle', 'tooltip'
      .off "click"
      .on "click", login_logout