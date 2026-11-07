```julia
prevpow(a, x)
```

`x` 以下の最大の `a^n`。ここで、`n` は非負の整数です。`a` は 1 より大きく、`x` は 1 未満であってはなりません。

関連項目: [`nextpow`](@ref)、[`isqrt`](@ref)。

# Examples

```jldoctest
julia> prevpow(2, 7)
4

julia> prevpow(2, 9)
8

julia> prevpow(5, 20)
5

julia> prevpow(4, 16)
16
```
