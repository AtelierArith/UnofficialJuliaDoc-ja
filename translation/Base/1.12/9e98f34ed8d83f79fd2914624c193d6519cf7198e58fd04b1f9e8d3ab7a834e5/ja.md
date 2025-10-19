```julia
ispow2(n::Number) -> Bool
```

`n`が整数の2の累乗であるかどうかをテストします。

関連情報としては [`count_ones`](@ref), [`prevpow`](@ref), [`nextpow`](@ref) があります。

# 例

```jldoctest
julia> ispow2(4)
true

julia> ispow2(5)
false

julia> ispow2(4.5)
false

julia> ispow2(0.25)
true

julia> ispow2(1//8)
true
```

!!! compat "Julia 1.6"
    非`Integer`引数のサポートはJulia 1.6で追加されました。

