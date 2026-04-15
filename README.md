# ExbrandSample

This is a Phoenix sample application for
[`exbrand`](https://github.com/nasshu2916/exbrand).

## Prerequisites

This project references `ex_brand` as a local dependency.

```text
~/src/
  exbrand/
  exbrand_sample/
```

## Setup

```bash
mise install
mise run setup
```

## Run

```bash
mise run server
```

## Migrations

Apply:

```bash
mise run migrate
```

Reset:

```bash
mise run reset
```

Create a new migration:

```bash
mix ecto.gen.migration add_some_feature
```

## Validation

```bash
mise run precommit
```
