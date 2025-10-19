```julia
merge(a::NamedTuple, iterable)
```

イテラブルなキー-バリューのペアを名前付きタプルとして解釈し、マージを実行します。

```jldoctest
julia> merge((a=1, b=2, c=3), [:b=>4, :d=>5])
(a = 1, b = 4, c = 3, d = 5)
```
