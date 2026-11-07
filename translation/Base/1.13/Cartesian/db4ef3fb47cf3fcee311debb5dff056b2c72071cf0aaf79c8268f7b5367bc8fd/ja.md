```julia
@nextract N esym isym
```

`isym`から値を取り出すための変数`N`、`esym_1`、`esym_2`、...、`esym_N`を生成します。`isym`には、`Symbol`または無名関数式を指定できます。

`@nextract 2 x y`では次のように生成されます。

```julia
x_1 = y[1]
x_2 = y[2]
```

一方、`@nextract 3 x d->y[2d-1]`では次のようになります。

```julia
x_1 = y[1]
x_2 = y[3]
x_3 = y[5]
```
