---
---
## Navbar

**Collapsible**

```liquid
{% raw %}{% include bootstrap/collapsible.html md=markdown title="Title" schema=page.schema %}{% endraw %}
```

**Modal**

```html
<a href="#" data-toggle="modal" data-target="#idModal">Modal link</a>
```

```liquid
{% raw %}{% include bootstrap/modal.html id="idModal" title="Title" md=markdown large=true fade=true %}{% endraw %}
```