```
undef
```

`UndefInitializer()`のエイリアスで、配列初期化に使用されるシングルトン型[`UndefInitializer`](@ref)のインスタンスを構築します。これは、配列コンストラクタ呼び出し元が初期化されていない配列を希望していることを示します。

関連情報: [`missing`](@ref), [`similar`](@ref).

# 例

```julia-repl
julia> Array{Float64, 1}(undef, 3)
3-element Vector{Float64}:
 2.2752528595e-314
 2.202942107e-314
 2.275252907e-314
```
