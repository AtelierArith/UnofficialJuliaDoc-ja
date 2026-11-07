```julia
replace(A, old_new::Pair...; [count::Integer])
```

`A`のコピーを返します。`old_new`内の各`old=>new`について、`old`のすべての出現箇所を`new`に置き換えます。等価性の判定には[`isequal`](@ref)を使用します。`count`が指定されている場合、置換する出現箇所の合計は最大でも`count`個です。

結果の要素型は、`A`の要素型と、ペア内の`new`の値の型に基づき、昇格（[`promote_type`](@ref)を参照）によって決まります。`count`が省略され、`A`の要素型が`Union`である場合、結果の要素型には、異なる型の値に置き換えられるシングルトン型は含まれません。たとえば、`missing`が置き換えられると、`Union{T,Missing}`は`T`になります。

関連項目：[`replace!`](@ref)、[`splice!`](@ref)、[`delete!`](@ref)、[`insert!`](@ref)。

!!! compat "Julia 1.7"
    `Tuple`の要素を置換するには、バージョン1.7が必要です。


# Examples

```jldoctest
julia> replace([1, 2, 1, 3], 1=>0, 2=>4, count=2)
4-element Vector{Int64}:
 0
 4
 1
 3

julia> replace([1, missing], missing=>0)
2-element Vector{Int64}:
 1
 0
```
