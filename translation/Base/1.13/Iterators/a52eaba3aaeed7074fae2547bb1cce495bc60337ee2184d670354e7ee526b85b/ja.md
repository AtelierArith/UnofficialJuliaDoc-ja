```julia
only(x)
```

コレクション `x` の要素が1つだけならそれを返し、要素が0個または複数ある場合は [`ArgumentError`](@ref) をスローします。

関連項目: [`first`](@ref)、[`last`](@ref)。

!!! compat "Julia 1.4"
    このメソッドを使用するには、Julia 1.4 以降が必要です。


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
