```julia
view(A, inds...)
```

[`getindex`](@ref)と同様ですが、指定されたインデックスまたはインデックスの集合`inds`に対して親配列`A`を遅延参照する軽量配列を返します。要素を即座に抽出したり、コピーされた部分集合を構築するのではありません。返された値（しばしば[`SubArray`](@ref)）に対して[`getindex`](@ref)または[`setindex!`](@ref)を呼び出すと、親配列にアクセスまたは変更するためのインデックスがその場で計算されます。`view`が呼び出された後に親配列の形状が変更されると、動作は未定義になります。なぜなら、親配列に対する境界チェックがないからです。例えば、セグメンテーションフォルトを引き起こす可能性があります。

一部の不変の親配列（範囲など）は、効率的で互換性のあるセマンティクスを提供する場合、`SubArray`を返す代わりに新しい配列を再計算することを選択することがあります。

!!! compat "Julia 1.6"
    Julia 1.6以降では、`view`は`AbstractString`に対して呼び出すことができ、`SubString`を返します。


# 例

```jldoctest
julia> A = [1 2; 3 4]
2×2 Matrix{Int64}:
 1  2
 3  4

julia> b = view(A, :, 1)
2-element view(::Matrix{Int64}, :, 1) with eltype Int64:
 1
 3

julia> fill!(b, 0)
2-element view(::Matrix{Int64}, :, 1) with eltype Int64:
 0
 0

julia> A # bを変更したにもかかわらずAが変更されたことに注意
2×2 Matrix{Int64}:
 0  2
 0  4

julia> view(2:5, 2:3) # 型が不変であるため範囲を返す
3:4
```
