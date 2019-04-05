---
---

* toc
{:toc}

### Form

{% include bootstrap/collapsible.html schema=site.data.examples.schema title="site.data.examples.schema" %}

```liquid
{% raw %}{% include schema/form.html schema=site.data.examples.schema preview=true %}{% endraw %}
```

{% capture include %}{% include schema/form.html schema=site.data.examples.schema preview=true%}{% endcapture %}
{{ include }}
{% include template/api.html file="schema/form.html" %}

### Schema

```yml
title: Schema title
description: Schema description
properties:
  property_1:
    ...
  property_2:
    ...
```

{% capture api %}title string "properties" | Title of the schema
description string nil | Description of the schema
properties object nil | Properties of the schema{% endcapture %}
{% include template/api.html %}

### Property

Minimal text property:

```yml
property_name: true
```

##### Attributes

- `value` Initial value of the field
- `placeholder` Placeholder text for the field
- `required` The field is required during validation
- `readonly` The field cannot be changed, automatic for `template`, `eval`, `watch` and `pool.value`
- `exclude` The field is not saved, useful for pools

##### Type

`type` define an input field, can be `text`, `number`, `date`, `time`, `color`, `range`, `checkbox`, `radio`, `url` or `email`.

- **text** type can have `minlength` and `maxlength`
- **number** and **range** types can have `min` and `max`
- **range** type can have `step`

##### Schema

`schema` is a reference to another schema defined in the form's page front matter (es. `page.my_schema`) or in `site.data` space with a dot notation (es. `examples.my_schema` for the file `/_data/examples/my_schema.yml`)

##### Select

`select` define a dropdown list of items, can be a simple array of values or an array of objects. Objects can have `value`, `title`, `description`, `selected` and `optgroup` [group of options](https://developer.mozilla.org/en-US/docs/Web/HTML/Element/optgroup) properties.

**select** objects can have a `multiple: true` attribute for multiple choices, and limit item numbers for validation with `min` and `max`.

select** can be a reference: `select: options: <reference>`. The reference has to be an array of options and will be searched first on page front matters and then on `_data` space.

##### Watch

`watch` property will update the field value every time the watched property changes. If the `list` array is present the field value will be the corresponding option label.

##### Eval and Templates

`eval` (numeric) and `template` (strings) contains a javascript expression with *string interpolation* and is updated every time variabiles changes. Fields are addressed with the `#{...}` interpolation syntax, for example the average of properties `a` and `b` is `eval: (#{a} + #{b}) / 2` while a persona summary can be like `template: "#{Name} #{Surname} #{age} years old`.

Eval and template fields will have `readonly` attribute.

##### Pools

`pool` is a numeric property with a `value`, every property with a `pool: ref: <reference>` will be subtracted from the referenced pool. Pool will yields invalid form submission if negative.

To exclude the pool value from the saved object add `excluded: true`

##### Items

`items` is a reference to another schema, you can add or delete multiple occurrences and the property will be saved as an array.

##### Include file

{% include template/api.html file="schema/property.html" %}

### Properties

{% include template/api.html file="schema/properties.html" %}

### Field

Input field attributes

| Attribute       | Type       | Description |
|:----------------|:-----------|:------------|
| `aria-label`    | String     | Slug of the property |
| `data-path`     | String     | Dot separated path of the property in the object, a number is the array index |
| `data-number`   | Boolean    | If true the value will be saved as a number |
| `data-watch`    | String     | Slug of the watched property |
| `list`          | String     | Id of the datalist node |
| `data-digits`   | Number     | Number of decimal digits for the range UI only |
| `data-eval`     | Expression | Expression with string interpolation `#{...}` |
| `data-template` | Template   | Template with string interpolation `#{...}` |
| `data-pool`     | Number     | Initial numeric value of the pool |
| `data-pool_ref` | String     | Slug of the pooled property |

{% include template/api.html file="schema/field.html" %}