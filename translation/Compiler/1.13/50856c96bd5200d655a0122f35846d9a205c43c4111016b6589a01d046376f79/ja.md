```julia
lift_comparison!(cmp, compact::IncrementalCompact, idx::Int, stmt::Expr, 𝕃ₒ::AbstractLattice)
```

`cmp(φ(x, y)::Union{X,Y}, constant)`を`φ(cmp(x, constant), cmp(y, constant))`に置き換えます。このとき、`cmp(x, constant)`と`cmp(y, constant)`は、定数の`Bool`eansに置き換えられます。これにより、`Union`型の`cmp`に対して、コード生成時に高コストなコードが生成されるのを防ぎます。特に、反復プロトコルのパフォーマンス向上を目的としています。

```julia
while x !== nothing
    x = iterate(...)::Union{Nothing,Tuple{Any,Any}}
end
```
