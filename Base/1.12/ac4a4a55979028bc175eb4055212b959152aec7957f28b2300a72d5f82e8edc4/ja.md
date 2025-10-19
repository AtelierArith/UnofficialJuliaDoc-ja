```julia
findnext(pattern::AbstractString, string::AbstractString, start::Integer)
findnext(pattern::AbstractPattern, string::String, start::Integer)
```

`pattern`の次の出現を`string`内で`start`の位置から探します。`pattern`は文字列または正規表現のいずれかであり、その場合`string`は`String`型でなければなりません。

返り値は、一致するシーケンスが見つかったインデックスの範囲であり、`s[findnext(x, s, i)] == x`が成り立ちます：

`findnext("substring", string, i)` == `start:stop` であり、`string[start:stop] == "substring"` かつ `i <= start`、または一致しない場合は`nothing`です。

# 例

```jldoctest
julia> findnext("z", "Hello to the world", 1) === nothing
true

julia> findnext("o", "Hello to the world", 6)
8:8

julia> findnext("Lang", "JuliaLang", 2)
6:9
```
