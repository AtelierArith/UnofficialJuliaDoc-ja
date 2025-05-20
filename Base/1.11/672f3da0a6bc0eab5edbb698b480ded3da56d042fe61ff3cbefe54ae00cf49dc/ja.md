```
reverseind(v, i)
```

与えられたインデックス `i` に対して [`reverse(v)`](@ref) の中で、`v[reverseind(v,i)] == reverse(v)[i]` となる `v` の対応するインデックスを返します。（これは、`v` に非ASCII文字が含まれている場合には非自明なことがあります。）

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
