```julia
view(A, inds...)
```

[`getindex`](@ref)と似ていますが、要素をその場で取り出したり、コピーした部分配列を作成したりする代わりに、指定したインデックス`inds`で親配列`A`を遅延参照する（実質的にそのビューとなる）軽量な配列を返します。返された値（多くの場合、[`SubArray`](@ref)）に対して[`getindex`](@ref)または[`setindex!`](@ref)を呼び出すと、親配列にアクセスまたは変更するためのインデックスがその都度計算されます。親配列の境界チェックは行われないため、`view`の呼び出し後に親配列の形状を変更した場合の動作は未定義です。たとえば、セグメンテーション違反が発生することがあります。また、ビューの作成後に`inds`配列を変更した場合も、動作は未定義です。

範囲などの一部の不変な親配列では、効率的で互換性のある動作が得られる場合、`SubArray`を返す代わりに、新しい配列を再計算することがあります。

!!! compat "Julia 1.6"
    Julia 1.6以降では、`view`を`AbstractString`に対して呼び出すと、`SubString`が返されます。


# Examples

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

julia> A # Note A has changed even though we modified b
2×2 Matrix{Int64}:
 0  2
 0  4

julia> view(2:5, 2:3) # returns a range as type is immutable
3:4
```
