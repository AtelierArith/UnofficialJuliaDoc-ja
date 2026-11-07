```julia
findnext(pattern::AbstractString, string::AbstractString, start::Integer)
findnext(pattern::AbstractPattern, string::String, start::Integer)
```

`pattern` が `string` 内で、位置 `start` 以降に現れる次の箇所を検索します。`pattern` は文字列または正規表現を指定できます。正規表現の場合、`string` は `String` 型でなければなりません。

戻り値は、一致する並びが見つかったインデックスの範囲です。次の条件を満たします。`s[findnext(x, s, i)] == x`:

`findnext("substring", string, i)` == `start:stop` であり、`string[start:stop] == "substring"` および `i <= start` を満たす場合。一致しない場合は `nothing` です。

# Examples

```jldoctest
julia> findnext("z", "Hello to the world", 1) === nothing
true

julia> findnext("o", "Hello to the world", 6)
8:8

julia> findnext("Lang", "JuliaLang", 2)
6:9
```
