```julia
prevpow(a, x)
```

`n` が非負の整数である場合に、`x` 以下となる最大の `a^n`。`a` は 1 より大きく、`x` は 1 以上でなければなりません。

[`nextpow`](@ref)、[`isqrt`](@ref) も参照してください。

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
