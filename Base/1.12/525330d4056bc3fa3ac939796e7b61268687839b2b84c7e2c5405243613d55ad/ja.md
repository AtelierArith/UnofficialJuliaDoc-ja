```julia
mergewith!(combine, d::AbstractDict, others::AbstractDict...) -> d
mergewith!(combine)
merge!(combine, d::AbstractDict, others::AbstractDict...) -> d
```

他のコレクションからのペアでコレクションを更新します。同じキーを持つ値は、コンバイナ関数を使用して結合されます。カリー形式の `mergewith!(combine)` は、関数 `(args...) -> mergewith!(combine, args...)` を返します。

メソッド `merge!(combine::Union{Function,Type}, args...)` は `mergewith!(combine, args...)` のエイリアスとして、後方互換性のためにまだ利用可能です。

!!! compat "Julia 1.5"
    `mergewith!` は Julia 1.5 以降が必要です。


# 例

```jldoctest
julia> d1 = Dict(1 => 2, 3 => 4);

julia> d2 = Dict(1 => 4, 4 => 5);

julia> mergewith!(+, d1, d2);

julia> d1
Dict{Int64, Int64} with 3 entries:
  4 => 5
  3 => 4
  1 => 6

julia> mergewith!(-, d1, d1);

julia> d1
Dict{Int64, Int64} with 3 entries:
  4 => 0
  3 => 0
  1 => 0

julia> foldl(mergewith!(+), [d1, d2]; init=Dict{Int64, Int64}())
Dict{Int64, Int64} with 3 entries:
  4 => 5
  3 => 0
  1 => 4
```
