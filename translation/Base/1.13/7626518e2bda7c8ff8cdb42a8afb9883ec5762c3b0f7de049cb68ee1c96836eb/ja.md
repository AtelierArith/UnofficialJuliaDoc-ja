```julia
ndigits0z(n::Integer, b::Integer=10)
```

`n == 0` の場合は 0 を返します。それ以外の場合は、整数 `n` を `b` 進法で表したときの桁数を計算します（この場合は `ndigits(n, base=b)` と等しくなります）。基数 `b` は `[-1, 0, 1]` であってはなりません。

# Examples

```jldoctest
julia> Base.ndigits0z(0, 16)
0

julia> Base.ndigits(0, base=16)
1

julia> Base.ndigits0z(0)
0

julia> Base.ndigits0z(10, 2)
4

julia> Base.ndigits0z(10)
2
```

[`ndigits`](@ref) を参照してください。
