```julia
reverseind(v, i)
```

与えられたインデックス `i` に対して [`reverse(v)`](@ref) の中で、`v[reverseind(v,i)] == reverse(v)[i]` となる `v` 内の対応するインデックスを返します。 （`v` に非ASCII文字が含まれる場合、これは非自明な場合があります。）

# 例

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
