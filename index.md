---
---
**`site.html_pages`**

{% for html_page in site.html_pages %}- {{ html_page.name }} <{{ html_page.url | absolute_url }}>
{% endfor %}