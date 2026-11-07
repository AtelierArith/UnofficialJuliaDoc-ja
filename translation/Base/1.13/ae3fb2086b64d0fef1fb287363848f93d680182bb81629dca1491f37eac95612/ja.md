```julia
merge(a::NamedTuple, iterable)
```

キーと値のペアの反復可能オブジェクトを名前付きタプルとして解釈し、マージを行います。

```jldoctest
julia> merge((a=1, b=2, c=3), [:b=>4, :d=>5])
(a = 1, b = 4, c = 3, d = 5)
```
