# ExbrandSample

`examples/customer_portal` の機能を移植した Phoenix サンプルです。

## 前提

`ex_brand` をローカル依存として参照します。

```text
~/src/
  exbrand/
  exbrand_sample/
```

## セットアップ

```bash
mise install
mise run setup
```

## 起動

```bash
mise run server
```

## マイグレーション

適用:

```bash
mise run migrate
```

リセット:

```bash
mise run reset
```

追加:

```bash
mix ecto.gen.migration add_some_feature
```

## 検証

```bash
mise run precommit
```
