```julia
findnext(pattern::AbstractString, string::AbstractString, start::Integer)
findnext(pattern::AbstractPattern, string::String, start::Integer)
```

`start` の位置から始めて、`string` 内で `pattern` が次に現れる位置を検索します。`pattern` は文字列または正規表現で、その場合、`string` は `String` 型でなければなりません。

戻り値は、一致した並びが見つかったインデックス範囲です。次の条件を満たします。`s[findnext(x, s, i)] == x`:

`findnext("substring", string, i)` == `start:stop` であり、`string[start:stop] == "substring"` および `i <= start` を満たす場合。一致しなければ `nothing` です。

# Examples

```jldoctest
julia> findnext("z", "Hello to the world", 1) === nothing
true

julia> findnext("o", "Hello to the world", 6)
8:8

julia> findnext("Lang", "JuliaLang", 2)
6:9
```
