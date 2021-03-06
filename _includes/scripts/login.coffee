###
  Need:
  - Bootstrap modal id="loginModal"
  - Form id="loginModalContent" with a type="submit" <button> and a div.invalid-feedback
  - Login link with data-toggle="modal" and data-target="#loginModal"
  - Token input id="personalToken"
###
login = {
  form: $ '#loginModalContent'
  modal: $ '#loginModal'
  token: $ '#personalToken'
  link: $ "[data-target='#loginModal']"
  submit: $ "#loginModalContent button[type='submit']"
  spinner: $ "#loginModalContent button[type='submit'] span[class*='spinner']"
  feedback: $ "#loginModalContent .invalid-feedback"
  init: () ->
    login.form.on "submit", login.serve
    if storage.get("login.token") and login.link.text() == "Login"
      login.link.text 'Logout'
        .attr 'title', "Logged as #{storage.get("login.user")}"
        .attr 'data-toggle', 'tooltip'
        .off "click"
        .on "click", login.logout
    true
  serve: (e) ->
    e.preventDefault()
    login.submit.prop "disabled", true
    login.spinner.removeClass 'd-none'
    login.token.removeClass "is-invalid"
    $.ajax "{{ site.github.api_url }}/user",
      method: "GET"
      headers: {"Authorization": "token #{login.token.val()}"}
      success: login.success
      error: login.error
      complete: login.complete
    true
  complete: (request, status) ->
    login.submit.prop "disabled", false
    login.spinner.addClass "d-none"
  success: (data, status) ->
    login.modal.modal "hide"
    storage.set "login.token", login.token.val()
      .set "login.user", data.login
      .set "login.created", new Date()
    login.link.text "Logout"
      .attr "data-original-title", "Logged as #{data.login}"
      .attr "data-toggle", "tooltip"
      .tooltip "show"
      .off "click"
      .on "click", login.logout
    setTimeout ->
      login.link.tooltip "dispose"
      login.token.val ""
    , 3000
    true
  error: (request, status, error) ->
    login.feedback.html "#{status}: #{error}"
    login.token.addClass "is-invalid"
    true
  logout: (e) ->
    e.preventDefault()
    storage.clear()
    $(e.target).text "Login"
      .attr "data-original-title", "Logged Out"
      .tooltip "show"
      .off "click"
    setTimeout ->
      $(e.target).attr "data-toggle", "modal"
        .tooltip "dispose"
    , 3000
    true
}
login.init()