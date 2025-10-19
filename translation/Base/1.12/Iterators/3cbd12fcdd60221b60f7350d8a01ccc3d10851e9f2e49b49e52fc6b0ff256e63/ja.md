```julia
only(x)
```

コレクション `x` の唯一の要素を返すか、コレクションがゼロまたは複数の要素を持つ場合は [`ArgumentError`](@ref) をスローします。

他にも [`first`](@ref)、[`last`](@ref) を参照してください。

!!! compat "Julia 1.4"
    このメソッドは少なくとも Julia 1.4 を必要とします。


# 例

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
