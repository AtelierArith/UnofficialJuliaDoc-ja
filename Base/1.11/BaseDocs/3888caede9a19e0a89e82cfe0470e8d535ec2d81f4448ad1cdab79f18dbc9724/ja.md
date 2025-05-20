```
UndefInitializer
```

配列初期化に使用されるシングルトン型で、配列コンストラクタ呼び出し元が初期化されていない配列を希望していることを示します。`undef`[@ref]のエイリアスである`UndefInitializer()`も参照してください。

# 例

```julia-repl
julia> Array{Float64, 1}(UndefInitializer(), 3)
3-element Array{Float64, 1}:
 2.2752528595e-314
 2.202942107e-314
 2.275252907e-314
```
