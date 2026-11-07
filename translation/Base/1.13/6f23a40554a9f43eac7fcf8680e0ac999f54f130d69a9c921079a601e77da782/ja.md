```julia
mergewith!(combine, d::AbstractDict, others::AbstractDict...) -> d
mergewith!(combine)
merge!(combine, d::AbstractDict, others::AbstractDict...) -> d
```

他のコレクションのペアを使ってコレクションを更新します。同じキーを持つ値は、結合関数を使って結合されます。カリー化形式の`mergewith!(combine)`は、関数`(args...) -> mergewith!(combine, args...)`を返します。

`mergewith!(combine, args...)`の別名であるメソッド`merge!(combine::Union{Function,Type}, args...)`は、後方互換性のため引き続き利用できます。

!!! compat "Julia 1.5"
    `mergewith!`にはJulia 1.5以降が必要です。


# Examples

```jldoctest; filter = r"^\s+\S+\s+=>\s+\d$"m
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
