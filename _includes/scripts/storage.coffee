###
  Store an object in `localStorage`, LZ compressed to Base 64. The key si the string {{ site.github.repository_url }}{{ page.url | absolute_url }}
  @example
  // Initialize storage in localStorage, called the first `get` or `set`
  storage.init()
  @example
  // Remove a key value pair or clear whole object
  storage.clear([key])
  @example
  // Set a value for a key
  storage.set(key, value)
  @example
  // Get a key's value or whole object
  storage.get(key)
  @example
  // Low level compression and storage
  storage.store(obj)
###
storage = {
  key: () ->
    return  '{{ site.github.repository_url }}{{ page.url | absolute_url }}'
  init: () ->
    if !localStorage.getItem(storage.key())? then storage.store {
      "created": new Date()
      "version": '{{ site.github.latest_release.tag_name }}'
      "url": '{{ page.url | absolute_url }}'
      "repository": '{{ site.github.repository_url }}'
    }
    true
  clear: (key) ->
    obj = storage.get()
    if key?
      delete obj[key]
      storage.store obj
    else
      localStorage.removeItem storage.key()
    true
  set: (key, value) ->
    storage.init()
    obj = storage.get()
    if key? and value?
      obj[key] = value
      storage.store obj
      return storage # for multiple storage
    else
      return false
  get: (key) ->
    storage.init()
    if key?
      storage.get()[key]
    else
      JSON.parse LZString.decompressFromBase64 localStorage.getItem storage.key()
  store: (obj) ->
    localStorage.setItem storage.key(), LZString.compressToBase64 JSON.stringify obj
}
