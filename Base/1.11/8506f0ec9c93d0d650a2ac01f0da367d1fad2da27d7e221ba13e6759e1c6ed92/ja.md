```
@atomicswap a.b.x = new
@atomicswap :sequentially_consistent a.b.x = new
```

`new`を`a.b.x`に格納し、`a.b.x`の古い値を返します。

この操作は`swapproperty!(a.b, :x, new)`呼び出しに変換されます。

詳細については、マニュアルの[Per-field atomics](@ref man-atomics)セクションを参照してください。

# 例

```jldoctest
julia> mutable struct Atomic{T}; @atomic x::T; end

julia> a = Atomic(1)
Atomic{Int64}(1)

julia> @atomicswap a.x = 2+2 # aのフィールドxを4に置き換え、逐次的整合性を持つ
1

julia> @atomic a.x # aのフィールドxを取得し、逐次的整合性を持つ
4
```

!!! compat "Julia 1.7"
    この機能は少なくともJulia 1.7が必要です。

