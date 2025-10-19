```julia
join([io::IO,] iterator [, delim [, last]])
```

任意の `iterator` を単一の文字列に結合し、隣接するアイテムの間に指定された区切り文字（ある場合）を挿入します。 `last` が指定されている場合、最後の2つのアイテムの間には `delim` の代わりにそれが使用されます。 `iterator` の各アイテムは `print(io::IOBuffer, x)` を介して文字列に変換されます。 `io` が指定されている場合、結果は `String` として返されるのではなく、`io` に書き込まれます。

# 例

```jldoctest
julia> join(["apples", "bananas", "pineapples"], ", ", " and ")
"apples, bananas and pineapples"

julia> join([1,2,3,4,5])
"12345"
```
