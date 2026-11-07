```julia
nextpow(a, x)
```

`n` が非負の整数であるとき、`x` 以上となる最小の `a^n`。`a` は 1 より大きく、`x` は 0 より大きくなければなりません。

[`prevpow`](@ref) を参照してください。

# Examples

```jldoctest
julia> nextpow(2, 7)
8

julia> nextpow(2, 9)
16

julia> nextpow(5, 20)
25

julia> nextpow(4, 16)
16
```
