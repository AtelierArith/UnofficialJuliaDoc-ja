```julia
map(f, c...) -> collection
```

コレクション `c` を変換し、各要素に `f` を適用します。複数のコレクション引数がある場合、要素ごとに `f` を適用し、いずれかが尽きた時点で停止します。

結果の要素型は [`collect`](@ref) と同様の方法で決定されます。

他に [`map!`](@ref)、[`foreach`](@ref)、[`mapreduce`](@ref)、[`mapslices`](@ref)、[`zip`](@ref)、[`Iterators.map`](@ref) も参照してください。

# 例

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
