```julia
dot(x, A, y)
```

2つのベクトル `x` と `y` の一般化内積 `dot(x, A*y)` を計算します。中間結果 `A*y` は保存されません。2引数の [`dot(_,_)`](@ref) と同様に、これは再帰的に動作します。また、複素ベクトルの場合は、第1ベクトルの複素共役を取ります。

!!! compat "Julia 1.4"
    3引数の `dot` を使用するには、Julia 1.4以降が必要です。


# Examples

```jldoctest
julia> dot([1; 1], [1 2; 3 4], [2; 3])
26

julia> dot(1:5, reshape(1:25, 5, 5), 2:6)
4850

julia> ⋅(1:5, reshape(1:25, 5, 5), 2:6) == dot(1:5, reshape(1:25, 5, 5), 2:6)
true
```
