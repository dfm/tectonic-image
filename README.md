# tectonic-image

A lightweight docker image for [tectonic](https://tectonic-typesetting.github.io/en-US/)

## Usage on GitHub Actions

The main place I wanted to use this was on GitHub actions. Here is a minimal
example:

```yaml
name: "Compile TeX"
on:
  push:
    branches: [main]
jobs:
  test_image:
    runs-on: ubuntu-latest
    needs: docker_image
    steps:
      - uses: actions/checkout@v2
      - uses: docker://ghcr.io/dfm/tectonic-image:main
        with:
          args: path/to/document.tex
```

It's a little finicky to get caching to work, but you can do something like the
following:

```yaml
name: "Compile TeX"
on:
  push:
    branches: [main]
jobs:
  test_image:
    runs-on: ubuntu-latest
    needs: docker_image
    steps:
      - uses: actions/checkout@v2

      - uses: actions/cache@v2
        with:
          path: |
            cache/Tectonic/*
            !cache/Tectonic/formats
          key: tectonic-cache-${{ github.sha }}
          restore-keys: |
            tectonic-cache-

      - uses: docker://ghcr.io/dfm/tectonic-image:main
        with:
          args: path/to/document.tex
        env:
          XDG_CACHE_HOME: /github/workspace/cache
```
