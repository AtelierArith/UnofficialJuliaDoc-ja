```julia
map(f, c...) -> collection
```

コレクション `c` の各要素に `f` を適用して変換します。複数のコレクションを引数に指定した場合は、`f` を要素ごとに適用し、いずれかのコレクションの要素がなくなった時点で処理を終了します。

結果の要素型は、[`collect`](@ref) と同じ方法で決定されます。

関連項目: [`map!`](@ref)、[`foreach`](@ref)、[`mapreduce`](@ref)、[`mapslices`](@ref)、[`zip`](@ref)、[`Iterators.map`](@ref)。

# Examples

```jldoctest
julia> map(x -> x * 2, [1, 2, 3])
3-element Vector{Int64}:
 2
 4
 6

julia> map(+, [1, 2, 3], [10, 20, 30, 400, 5000])
3-element Vector{Int64}:
 11
 22
 33
```
