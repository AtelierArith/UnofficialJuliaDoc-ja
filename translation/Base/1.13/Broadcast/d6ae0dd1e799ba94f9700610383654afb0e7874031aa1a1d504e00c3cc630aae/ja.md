```julia
broadcast!(f, dest, As...)
```

[`broadcast`](@ref)と同様ですが、`broadcast(f, As...)`の結果を`dest`配列に格納します。`dest`は結果の格納にのみ使用され、`As`にも記載されていない限り、`f`に引数を渡さない点に注意してください。たとえば、`broadcast!(f, A, A, B)`で`A[:] = broadcast(f, A, B)`を実行する場合がこれに該当します。

# Examples

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
