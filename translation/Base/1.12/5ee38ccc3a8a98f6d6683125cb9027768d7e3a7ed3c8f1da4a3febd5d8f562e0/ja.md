```julia
objectid(x) -> UInt
```

オブジェクトのアイデンティティに基づいて `x` のハッシュ値を取得します。

もし `x === y` であれば `objectid(x) == objectid(y)` となり、通常 `x !== y` の場合は `objectid(x) != objectid(y)` となります。

他にも [`hash`](@ref)、[`IdDict`](@ref) を参照してください。
