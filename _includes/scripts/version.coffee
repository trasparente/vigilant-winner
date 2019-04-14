version = {
  update: (e) ->
    version.check "{{ site.github.repository_nwo }}"
      .then (data) ->
        storage.set "repository.updated_at", data.updated_at
        console.log data
        message = "repository.updated_at #{data.updated_at}"
        if storage.get("login.token") and "{{ site.remote_theme }}"
          version.check "{{ site.remote_theme }}"
            .then (remote) ->
              storage.set "remote_theme.updated_at", remote.updated_at
              message += " remote_theme.updated_at #{remote.updated_at}"
              console.log new Date(data.updated_at).getTime(), new Date(remote.updated_at).getTime()
        modal_alert message
        return
    return
  check: (repo) ->
    return $.ajax "{{ site.github.api_url }}/repos/#{repo}",
      method: "GET"
  # note used
  success: (data, status) ->
    storage.set "#{data.full_name}_updated_at", data.updated_at
    return
  # note used
  error: (request, status, error) ->
    console.log status
    return
}