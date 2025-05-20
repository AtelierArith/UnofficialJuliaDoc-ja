```
clamp(x, T)::T
```

`x`を`typemin(T)`と`typemax(T)`の間に制限し、結果を型`T`に変換します。

関連情報は[`trunc`](@ref)を参照してください。

# 例

```jldoctest
julia> clamp(200, Int8)
127

julia> clamp(-200, Int8)
-128

julia> trunc(Int, 4pi^2)
39
```
