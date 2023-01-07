---
title: Changelog
---

This changelog tries to be quite complete, and as such contains technical
details.

# 2022-12-17

This changelog entry is about the initial version of Refli, as visible on
[refli.be](https://refli.be). The [Git
repository](https://github.com/hypered/refli.be) has more content which is not
written down here.

- [refli.be](https://refli.be) is a static site made of a few pages, mainly written in French:
  - The [homepage](/).
  - An ["about"](/pages/about.md) page.
  - This ["changelog"](/pages/changelog.md) page.
  - A ["contact"](/pages/contact.md) page.
  - A (currently empty) ["disclaimer"](/pages/disclaimer.md) page.
- It is deployed on DigitalOcean as an Nginx Nix configuration. That
  configuration is used in a NixOS VM image which is not part of Refli itself.
- The pages are written using Markdown, and rendered to HTML using Pandoc. They
  use the Hypered [design system](https://github.com/hypered/design)
  (which is currently not yet a real design system, nor very mature).
- Each rendered page has a link to its source Markdown file on GitHub.

<br />
<br />
<br />
