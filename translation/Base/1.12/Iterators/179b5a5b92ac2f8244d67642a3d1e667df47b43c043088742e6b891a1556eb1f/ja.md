```julia
Iterators.accumulate(f, itr; [init])
```

2つの引数を持つ関数 `f` とイテレータ `itr` を与えると、前の値と `itr` の次の要素に `f` を順次適用する新しいイテレータを返します。

これは実質的に [`Base.accumulate`](@ref) の遅延バージョンです。

!!! compat "Julia 1.5"
    キーワード引数 `init` は Julia 1.5 で追加されました。


# 例

```jldoctest
julia> a = Iterators.accumulate(+, [1,2,3,4]);

julia> foreach(println, a)
1
3
6
10

julia> b = Iterators.accumulate(/, (2, 5, 2, 5); init = 100);

julia> collect(b)
4-element Vector{Float64}:
 50.0
 10.0
  5.0
  1.0
```
