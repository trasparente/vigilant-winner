# COMMIT function
commit = (e, file, object) ->
  e.preventDefault()
  form = $ e.target
  load = YAML.stringify object, 8, 2
  submit = form.find "[type='submit']"
  spinner = submit.find "span[class*='spinner']"
  feedback = form.find ".invalid-feedback"
  commit_url = "{{ site.github.api_url }}/repos/{{ site.github.repository_nwo }}/contents/_data/#{file}"
  if file == "" then feedback.text("Input a valid path").addClass "d-block"
  get_sha = () ->
    submit.prop "disabled", true
    spinner.removeClass 'd-none'
    $.ajax commit_url,
      method: 'GET'
      headers:
        authorization: "token #{storage.get('token')}"
        accept: "application/vnd.github.v3.full+json"
      success: update_file
      error: error_sha
    true
  error_sha = (request, status, error) ->
    if error == 'Not Found'
      create_file()
    else
      submit.prop "disabled", false
      spinner.addClass "d-none"
      feedback.text("get_sha(): #{status} #{error}").addClass "d-block"
    true
  ###  
  Create new file
  @param message {string}
  @param content {string}
  ###
  create_file = () ->
    # PUT /repos/:owner/:repo/contents/:path
    $.ajax commit_url,
      method: 'PUT'
      headers: "Authorization": "token #{storage.get('token')}"
      data: JSON.stringify {
        message: "create_file #{file}"
        content: btoa load
      }
      success: file_created
      error: error
    true
  error = (request, status, error) ->
    submit.prop "disabled", false
    spinner.addClass "d-none"
    feedback.text("create_file: #{status} #{error}").addClass "d-block"
    true
  update_file = (data, status) ->
    # Commit
    $.ajax commit_url,
      method: 'PUT'
      headers: "Authorization": "token #{storage.get('token')}"
      data: JSON.stringify {
        message: "update_file #{file}"
        sha: data.sha
        content: btoa load
      }
      success: file_updated
      error: error
    true
  file_updated = (data, status) ->
    console.log data
    store_sha data
    feedback.text("file_updated: #{status} #{data}").addClass "d-block"
    true
  file_created = (data, status) ->
    store_sha data
    feedback.text("file_created: #{status} #{data}").addClass "d-block"
    true
  store_sha = (data) ->
    submit.prop "disabled", false
    spinner.addClass "d-none"
    storage.set 'update_sha', data.sha
    console.log data
    true
  # Start commit
  get_sha()
  return