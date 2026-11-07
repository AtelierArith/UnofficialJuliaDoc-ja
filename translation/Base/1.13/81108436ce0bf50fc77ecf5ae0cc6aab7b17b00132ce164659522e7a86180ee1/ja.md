```julia
join([io::IO,] iterator [, delim [, last]])
```

`iterator`を1つの文字列に連結します。隣接する項目の間には、指定されている場合は区切り文字を挿入します。`last`が指定されている場合、最後の2つの項目の間には`delim`の代わりにそれを使用します。`iterator`の各項目は、`print(io::IOBuffer, x)`によって文字列に変換されます。`io`が指定されている場合、結果は返される`String`ではなく、`io`に書き込まれます。

# Examples

```jldoctest
julia> join(["apples", "bananas", "pineapples"], ", ", " and ")
"apples, bananas and pineapples"

julia> join([1,2,3,4,5])
"12345"
```
