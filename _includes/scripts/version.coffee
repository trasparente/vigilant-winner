version = {
  update: (e) ->
    version.check "{{ site.github.repository_nwo }}"
      .then (data) ->
        storage.set "#{data.full_name}_updated_at", data.updated_at
        console.log data
        if storage.get("token") and "{{ site.remote_theme }}"
          version.check "{{ site.remote_theme }}"
            .then (remote) ->
              storage.set "#{remote.full_name}_updated_at", remote.updated_at
              console.log data.updated_at.getTime(), remote.updated_at.getTime()
        return
    return
  check: (repo) ->
    return $.ajax "{{ site.github.api_url }}/repos/#{repo}",
      method: "GET"
      headers: {"Authorization": "token #{storage.get('token')}"}
  # note used
  success: (data, status) ->
    storage.set "#{data.full_name}_updated_at", data.updated_at
    return
  # note used
  error: (request, status, error) ->
    console.log status
    return
}