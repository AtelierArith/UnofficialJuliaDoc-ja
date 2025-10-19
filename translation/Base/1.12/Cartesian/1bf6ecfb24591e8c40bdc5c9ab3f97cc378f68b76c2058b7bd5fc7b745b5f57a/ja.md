```julia
@ncall N f sym...
```

関数呼び出し式を生成します。`sym`は任意の数の関数引数を表し、最後の引数は無名関数式である可能性があり、`N`個の引数に展開されます。

例えば、`@ncall 3 func a`は次のようになります。

```julia
func(a_1, a_2, a_3)
```

一方、`@ncall 2 func a b i->c[i]`は次のようになります。

```julia
func(a, b, c[1], c[2])
```
