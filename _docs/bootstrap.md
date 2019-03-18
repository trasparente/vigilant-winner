---
---
## Navbar

**Fixed top**

`fixed-top` class need `body { padding-top: 3.5em; }` because body line height (1.5), .navbar and .nav-link vertical padding (1 each).

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