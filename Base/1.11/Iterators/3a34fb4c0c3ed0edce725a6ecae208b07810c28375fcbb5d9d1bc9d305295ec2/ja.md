```
flatten(iter)
```

イテレータを受け取り、そのイテレータがイテレータを生成する場合、これらのイテレータの要素を生成するイテレータを返します。言い換えれば、引数のイテレータの要素が連結されます。

# 例

```jldoctest
julia> collect(Iterators.flatten((1:2, 8:9)))
4-element Vector{Int64}:
 1
 2
 8
 9

julia> [(x,y) for x in 0:1 for y in 'a':'c']  # Iterators.flattenを含むジェネレータを収集
6-element Vector{Tuple{Int64, Char}}:
 (0, 'a')
 (0, 'b')
 (0, 'c')
 (1, 'a')
 (1, 'b')
 (1, 'c')
```
