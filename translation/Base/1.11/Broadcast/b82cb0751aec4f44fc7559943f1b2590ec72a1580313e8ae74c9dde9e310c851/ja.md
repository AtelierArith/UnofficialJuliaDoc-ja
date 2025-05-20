```
broadcast!(f, dest, As...)
```

[`broadcast`](@ref)と同様ですが、`broadcast(f, As...)`の結果を`dest`配列に格納します。`dest`は結果を格納するためだけに使用され、`As`にリストされていない限り、`f`に引数を供給することはありません。例えば、`broadcast!(f, A, A, B)`のようにして`A[:] = broadcast(f, A, B)`を実行します。

# 例

```jldoctest
julia> A = [1.0; 0.0]; B = [0.0; 0.0];

julia> broadcast!(+, B, A, (0, -2.0));

julia> B
2-element Vector{Float64}:
  1.0
 -2.0

julia> A
2-element Vector{Float64}:
 1.0
 0.0

julia> broadcast!(+, A, A, (0, -2.0));

julia> A
2-element Vector{Float64}:
  1.0
 -2.0
```
