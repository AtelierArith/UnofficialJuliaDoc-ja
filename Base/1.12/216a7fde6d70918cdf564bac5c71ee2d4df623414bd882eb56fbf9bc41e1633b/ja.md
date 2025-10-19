```julia
findprev(pattern::AbstractString, string::AbstractString, start::Integer)
```

`string`内の位置`start`から始まる`pattern`の前の出現を見つけます。

返り値は、マッチするシーケンスが見つかったインデックスの範囲であり、`s[findprev(x, s, i)] == x`となります：

`findprev("substring", string, i)` == `start:stop` であり、`string[start:stop] == "substring"` かつ `stop <= i`、または一致しない場合は`nothing`です。

# 例

```jldoctest
julia> findprev("z", "Hello to the world", 18) === nothing
true

julia> findprev("o", "Hello to the world", 18)
15:15

julia> findprev("Julia", "JuliaLang", 6)
1:5
```
