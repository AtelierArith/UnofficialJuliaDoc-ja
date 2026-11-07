```julia
findprev(pattern::AbstractString, string::AbstractString, start::Integer)
```

`start` の位置から `string` 内を検索し、`pattern` が最後に現れる位置を探します。

戻り値は、一致した並びが見つかったインデックスの範囲です。つまり、`s[findprev(x, s, i)] == x` の場合は次のようになります。

`findprev("substring", string, i)` == `start:stop` であり、`string[start:stop] == "substring"` と `stop <= i` を満たす場合です。一致しない場合は `nothing` です。

# Examples

```jldoctest
julia> findprev("z", "Hello to the world", 18) === nothing
true

julia> findprev("o", "Hello to the world", 18)
15:15

julia> findprev("Julia", "JuliaLang", 6)
1:5
```
