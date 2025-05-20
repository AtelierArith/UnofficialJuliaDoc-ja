```
replace(A, old_new::Pair...; [count::Integer])
```

コレクション `A` のコピーを返します。ここで、`old_new` の各ペア `old=>new` に対して、すべての `old` の出現が `new` に置き換えられます。等価性は [`isequal`](@ref) を使用して決定されます。`count` が指定されている場合、合計で最大 `count` の出現のみが置き換えられます。

結果の要素型は、`A` の要素型とペアの `new` 値の型に基づいて昇格を使用して選択されます（[`promote_type`](@ref] を参照）。`count` が省略され、`A` の要素型が `Union` の場合、結果の要素型には、異なる型の値で置き換えられる単一型は含まれません。たとえば、`Union{T,Missing}` は、`missing` が置き換えられると `T` になります。

他にも [`replace!`](@ref)、[`splice!`](@ref)、[`delete!`](@ref)、[`insert!`](@ref) を参照してください。

!!! compat "Julia 1.7"
    要素を `Tuple` の中で置き換えるには、バージョン 1.7 が必要です。


# 例

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
