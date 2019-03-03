---
---

* toc
{:toc}

# JSON Schema

- <https://cswr.github.io/JsonSchema/spec/semantics/>

Let S be a JSON schema, k be a key:value pair in S and J a JSON document.

**General Restrictions**

- k is `type`: `string` and J is a string.
- k is `type`: `number` and J is a number.
- k is `type`: `integer` and J is an integer.
- k is `type`: `boolean` and J is a boolean value.
- k is `type`: `null` and J is the value null.
- k is `type`: `array` and J is an array.
- k is `type`: `object` and J is an object.
- k is `type: [t1, ... ,tn]` and the type of J is ti for some ti in { t1, ..., tn }.
- k is `enum`: [j1, ... ,jn] and J = ji for some ji in { j1, ..., jn }.

**Strings Restrictions**

- k is of the form `minLength` : n and J is a string of length at least n.
- k is of the form `maxLength` : n and J is a string of length at most n.
- k is of the form `pattern` : `rexp` and J is a string that matches the regular expression rexp.

**Numeric Restrictions**

- k is `multipleOf`: r for some positive decimal number r, and J is a number that is a multpiple of r.
- k is `minimum`: r for some decimal r, and J is a number that is strictly greater than r.
- k is `minimum`: r for some decimal r, J is a number that is equal to r and the pair `exclusiveMinimum`: true is not in S.
- k is `maximum`: r, for some decimal r, and J is a number that is stricly less than r.
- k is `maximum`: r for some decimal r, J is a number that is equal to r and the pair `exclusiveMinimum`: true is not in S.

**Arrays Restrictions**

- k is `items`: S' and J is an array such that every element validates against S'.
- k is `items`: [s1 , ... , sn] and J is an array [a1 , ... , am] such that every element ai validates against si with i ≤ Min(m,n).
- k is `additionalItems`: true and J is an array.
- k is `additionalItems`: false, there is a key:value pair `items`: [s1 , ... , sn] in S and J is an array with at most n elements.
- k is `additionalItems`: false, and either S does not contain a pair with keyword `items`, or such pair is of the form `items`: S' (that is, the value of items is an object, not an array).
- k is `additionalItems`: S', S does not contain a pair with keyword `items` and J is an array such that every element validates against S'.
- k is `additionalItems`: S' and S contains a pair of the form `items`: S' (that is, the value of items is an object, not an array).
- k is `additionalItems`: S', S has a pair of form `items`: [s1 , ... , sn], and J is an array [a1 , ... , am] such that each ai, for i > n, validates against S'.
- k is `minItems`: n and J is an array with at least n elements.
- k is `maxItems`: n and J is an array with at most n elements.
- k is `uniqueItems`: true and J is an array with all elements different from each other.

**Object Restrictions**

- k is of the form `properties`: {k1: s1 , ... , kn: sn} and J is an object that for each key-value pair k': j' in J, if k' = ki for some i in [ 1 , ... , n ] then j' satisfies si.
- k is of the form `patternProperties`: {rexp1: s1 , ... , rexpn: sn} and J is an object such that for each key-value pair k': j' in J and every rexpi, i in [ 1 , ... , n ], such that k' is in the language of rexpi, then j' satisfies si.
- k is of the form `required`: [k1 , ... , kn] and each ki appears in J.
- k is of the form `minProperties`: n and J is an object with at least n key:value pairs.
- k is of the form `maxProperties`: n and J is an object with at most n key:value pairs.
- k is of the form `additionalProperties`: false and J is an object such that every keyword in J either belongs to properties(S) or matches at least one of the expressions in patternProperties(S)
- k is of the form `additionalProperties`: true and J is an object
- k is of the form `additionalProperties`: S' and J is an object such that for each key-value pair k': j' in J, with k' not in properties(S) and k' not matching any of the expressions in patternProperties(S), we have that j' validates against S'
- k is of the form `dependencies`: {k1: [l1,1 , ... ,l1,m1], ... , kn: [ln,1 , ... ,ln,mn]} and J is an object such that if ki appears in J then every keyword in [li,1 , ... ,li,mi] appears in J
- k is of the form `dependencies`: {k1: s1 , ... , kn: sn} and J is an object such that if ki appears in J then J must satisfy si

**Combinations**

- k is of the form `anyOf`: [{Sch1}, {Sch2}, ... ,{Schn}] and J validates against some Schi, for i=1...n
- k is of the form `allOf`: [{Sch1}, {Sch2}, ... ,{Schn}] and J validates against all of Schi, for i=1...n
- k is of the form `oneOf`: [{Sch1}, {Sch2}, ... ,{Schn}] and J validates against exactly one of Schi, for i=1...n
- k is of the form `not`: {Sch} and J does not validate against Sch

**Metadata**

- `$schema` keyword specifies the version of specification of JSON Schema.
- `title` keyword give a name to the schema.
- `description` keyword give a short description of what kind of documents the schema accepts.
- `default` keyword specify a default value for the document if a validator reads a missing value as input.

# Github metadata

- <https://github.com/petrosh/snippetrosh/issues/5#issuecomment-266549643>

Updated only on build

- `contributors`: user with pull request merged but does not have collaborator access (size = {{ site.github.contributors.size }}).
- `is_user_page`, `is_project_page`, `organization_members`: an organization will have at least one member ({{ site.github.is_user_page | inspect }} {{ site.github.is_project_page | inspect }} {{ site.github.organization_members | inspect }}).
- `public_repositories`: filtering the repositories and taking the first element you get `fork`, `forks`, `watchers`, `updated_at`{% assign condition = "item.html_url == '" | append: site.github.repository_url | append: "'" %}{% assign repository =  site.github.public_repositories | where_exp: "item", condition | first %} ({{ repository.fork }} {{ repository.forks }} {{ repository.watchers }} {{ repository.updated_at }})