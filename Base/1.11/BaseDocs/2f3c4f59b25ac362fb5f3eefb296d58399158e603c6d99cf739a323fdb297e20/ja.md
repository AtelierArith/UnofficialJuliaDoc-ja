```
Core.Type{T}
```

`Core.Type` は、すべての型オブジェクトをそのインスタンスとして持つ抽象型です。シングルトン型 `Core.Type{T}` の唯一のインスタンスはオブジェクト `T` です。

# 例

```jldoctest
julia> isa(Type{Float64}, Type)
true

julia> isa(Float64, Type)
true

julia> isa(Real, Type{Float64})
false

julia> isa(Real, Type{Real})
true
```
