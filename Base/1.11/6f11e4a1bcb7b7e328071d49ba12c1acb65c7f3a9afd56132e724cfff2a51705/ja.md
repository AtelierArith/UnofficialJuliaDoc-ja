```
NaN, NaN64
```

[`Float64`](@ref) 型の非数値（not-a-number）値です。

参照: [`isnan`](@ref), [`missing`](@ref), [`NaN32`](@ref), [`Inf`](@ref)。

# 例

```jldoctest
julia> 0/0
NaN

julia> Inf - Inf
NaN

julia> NaN == NaN, isequal(NaN, NaN), isnan(NaN)
(false, true, true)
```

!!! 注     `NaN` をチェックする際は、必ず [`isnan`](@ref) または [`isequal`](@ref) を使用してください。`x === NaN` を使用すると予期しない結果が得られることがあります：

````
```julia-repl
julia> reinterpret(UInt32, NaN32)
0x7fc00000

julia> NaN32p1 = reinterpret(Float32, 0x7fc00001)
NaN32

julia> NaN32p1 === NaN32, isequal(NaN32p1, NaN32), isnan(NaN32p1)
(false, true, true)
```
````
