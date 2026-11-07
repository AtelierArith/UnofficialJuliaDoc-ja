```julia
findprev(pattern::AbstractString, string::AbstractString, start::Integer)
```

位置 `start` を起点に、`string` 内で `pattern` が直前に出現する箇所を検索します。

戻り値は、一致するシーケンスが見つかったインデックスの範囲であり、`s[findprev(x, s, i)] == x` を満たします。

`string[start:stop] == "substring"` および `stop <= i` を満たす `findprev("substring", string, i)` == `start:stop`。一致しない場合は `nothing` を返します。

# Examples

```jldoctest
julia> findprev("z", "Hello to the world", 18) === nothing
true

julia> findprev("o", "Hello to the world", 18)
15:15

julia> findprev("Julia", "JuliaLang", 6)
1:5
```
