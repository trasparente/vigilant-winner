---
---
* toc
{:toc}

# Table of contents

```md
* toc
{:toc}
```

# Github metadata

- <https://github.com/petrosh/snippetrosh/issues/5#issuecomment-266549643>

Updated only on build

- `contributors`: user with pull request merged but does not have collaborator access (size = {{ site.github.contributors.size }}).
- `is_user_page`, `is_project_page`, `organization_members`: an organization will have at least one member ({{ site.github.is_user_page | inspect }} {{ site.github.is_project_page | inspect }} {{ site.github.organization_members | inspect }}).
{%- include load/repository.html -%}
- `public_repositories`: filtering the repositories and taking the first element you get `fork`, `forks`, `watchers`, `updated_at` ({{ repository.fork }} {{ repository.forks }} {{ repository.watchers }} {{ repository.updated_at | date_to_rfc822 }})