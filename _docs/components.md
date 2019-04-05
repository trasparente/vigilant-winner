---
---
* toc
{:toc}

# Jekyll

#### Table of contents

```md
* toc
{:toc}
```

Exclude a heading from toc:

```md
##### Excluded heading
{:.no_toc}
```

**todo:** sidebar via `ul#markdown-toc`

#### GitHub url

```liquid
{% raw %}{% include filter/github_url.html %}{% endraw %}
```
{% capture include %}{% include filter/github_url.html %}{% endcapture %}
{{ include }}
{% include template/api.html file="filter/github_url.html" %}

#### Unslug

```liquid
{% raw %}{% include filter/unslug.html string=site.github.repository_nwo %}{% endraw %}
```
{% capture include %}{% include filter/unslug.html string=site.github.repository_nwo %}{% endcapture %}
{{ include }}
{% include template/api.html file="filter/unslug.html" %}

# Bootstrap

#### Collapsible

```liquid
{% raw %}{% include bootstrap/collapsible.html body="Example" %}{% endraw %}
```
{% capture include %}{% include bootstrap/collapsible.html body="Example" %}{% endcapture %}
{{ include }}
{% include template/api.html file="bootstrap/collapsible.html" %}

#### Alert

```liquid
{% raw %}{% include bootstrap/alert.html body="Example" dismiss=true %}{% endraw %}
```
{% capture include %}{% include bootstrap/alert.html body="Example" dismiss=true %}{% endcapture %}
{{ include }}
{% include template/api.html file="bootstrap/alert.html" %}

#### Modal

```html
<a href="#" data-toggle="modal" data-target="#modal-id">Modal link</a>
```

```liquid
{% raw %}{% include bootstrap/modal.html body="Example" %}{% endraw %}
```
{% capture include %}{% include bootstrap/modal.html body="Example" %}{% endcapture %}
<a href="#" data-toggle="modal" data-target="#modal3">Modal link</a>
{{ include }}
{% include template/api.html file="bootstrap/modal.html" %}