```julia
flatten(iter)
```

イテレータを生成するイテレータを受け取り、それらのイテレータの要素を生成するイテレータを返します。言い換えると、引数のイテレータが生成する要素を連結します。

# Examples

```jldoctest
julia> collect(Iterators.flatten((1:2, 8:9)))
4-element Vector{Int64}:
 1
 2
 8
 9

julia> [(x,y) for x in 0:1 for y in 'a':'c']  # collects generators involving Iterators.flatten
6-element Vector{Tuple{Int64, Char}}:
 (0, 'a')
 (0, 'b')
 (0, 'c')
 (1, 'a')
 (1, 'b')
 (1, 'c')
```
