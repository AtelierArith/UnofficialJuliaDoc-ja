```julia
reverseind(v, i)
```

[`reverse(v)`](@ref) 内のインデックス `i` が与えられたとき、`v` 内で対応するインデックスを返します。これにより、`v[reverseind(v,i)] == reverse(v)[i]` が成り立ちます。（`v` に非 ASCII 文字が含まれる場合、これは単純ではありません。）

# Examples

```jldoctest
julia> s = "Julia🚀"
"Julia🚀"

julia> r = reverse(s)
"🚀ailuJ"

julia> for i in eachindex(s)
           print(r[reverseind(r, i)])
       end
Julia🚀
```
