# Typst packages

A monorepo of my packages, in the beginning for sure mostly unpublished. Search the official [packages](https://typst.app/docs/packages/) page to find out if something has been published.

This repo contains a few package authoring facilities which are heavily inspired by and based on those of [CeTZ](https://github.com/johannes-wolf/cetz). There is a [package template](./template) utilizing these (based on the [example package](https://github.com/typst/packages/tree/main/packages/preview/example)), and this README will eventually document the most important aspects. Even more fundamental package authoring concepts are documented in the [official Typst package repo](https://github.com/typst/packages).

CeTZ resources (`Justfile` and `scripts/*`) are licensed under the Apache License 2.0, the rest under the MIT LICENSE. Packages contain their own licenses. Feel free to clone this repo or its contents to start your own typst package monorepo. You will want to pretty much immediately change the template's author and repository metadata.

## Package structure

Required for all packages in general are

- `typst.toml`: package metadata
- `README.md`
- `LICENSE`
- (some entry point typst file)

The packaging tool is a little more opinionated and requires

- `src/`: containing the entry point and other typst files
- `gallery/`: for examples (that can at the same time serve as manual tests)
- `manual.typ`: the main documentation; the template uses [`tidy`](https://github.com/Mc-Zen/tidy) to generate this from the typst source

Note that even the gallery is _required_, and that the packaging tool actually also needs a `manual.pdf`.

When creating a new package by copying the template, at least the following should be checked/adapted:

- `typst.toml`:
	- change the package name and description
	- change the path in the repository URL
	- add keywords
- `typst.toml`, `LICENSE`: check if the license suits your needs
- `README.md`: change the title, add description
- `manual.typ`:
	- change the title and description
	- in the line `scope: (template: lib),` replace `template` with your package's name.
		This is the name under which your library will be imported in documentation comments.

## Building packages

You will need bash and [just](https://just.systems/man/en/).

First, generate the manual and gallery PDFs:

```
just manual template
just gallery template
```

(Replace `template` by the directory name of the package you're building.)

You can install your package locally to use it or perform some final tests:

```
just install template
```

Finally pack it up for publishing, e.g. into a directory named `dist`:

```
just package template dist
```