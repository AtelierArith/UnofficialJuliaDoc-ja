```julia
allunique(itr)::Bool
allunique(f, itr)::Bool
```

`itr` のすべての値が [`isequal`](@ref) と比較して互いに異なる場合は、`true` を返します。2つ目の方法では、`[f(x) for x in itr]` のすべての値が互いに異なる場合に返します。

`allunique(f, itr)` は、`f` を `length(itr)` 回より少なく呼び出すことがあります。呼び出し回数の正確な値は、実装の詳細とみなされます。

入力がソート済みの場合、`allunique` は専用の実装を使用することがあります。

関連項目: [`unique`](@ref)、[`issorted`](@ref)、[`allequal`](@ref)。

!!! compat "Julia 1.11"
    メソッド `allunique(f, itr)` を使用するには、Julia 1.11 以降が必要です。


# Examples

```jldoctest
julia> allunique([1, 2, 3])
true

julia> allunique([1, 2, 1, 2])
false

julia> allunique(Real[1, 1.0, 2])
false

julia> allunique([NaN, 2.0, NaN, 4.0])
false

julia> allunique(abs, [1, -1, 2])
false
```
