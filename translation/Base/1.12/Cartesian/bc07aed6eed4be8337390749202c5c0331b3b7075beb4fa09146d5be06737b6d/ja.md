```julia
@nextract N esym isym
```

`isym`から値を抽出するために`esym_1`、`esym_2`、...、`esym_N`の`N`個の変数を生成します。`isym`は`Symbol`または無名関数式のいずれかです。

`@nextract 2 x y`は次のように生成されます。

```julia
x_1 = y[1]
x_2 = y[2]
```

一方、`@nextract 3 x d->y[2d-1]`は次のようになります。

```julia
x_1 = y[1]
x_2 = y[3]
x_3 = y[5]
```
