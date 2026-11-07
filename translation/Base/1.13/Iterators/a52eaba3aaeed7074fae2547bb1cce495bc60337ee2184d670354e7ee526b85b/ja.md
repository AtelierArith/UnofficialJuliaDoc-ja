```julia
only(x)
```

コレクション `x` の唯一の要素を返します。コレクションの要素がゼロ個または複数個の場合は、[`ArgumentError`](@ref) をスローします。

[`first`](@ref)、[`last`](@ref) も参照してください。

!!! compat "Julia 1.4"
    このメソッドには Julia 1.4 以降が必要です。


# Examples

```jldoctest
julia> only(["a"])
"a"

julia> only("a")
'a': ASCII/Unicode U+0061 (category Ll: Letter, lowercase)

julia> only(())
ERROR: ArgumentError: Tuple contains 0 elements, must contain exactly 1 element
Stacktrace:
[...]

julia> only(('a', 'b'))
ERROR: ArgumentError: Tuple contains 2 elements, must contain exactly 1 element
Stacktrace:
[...]
```
