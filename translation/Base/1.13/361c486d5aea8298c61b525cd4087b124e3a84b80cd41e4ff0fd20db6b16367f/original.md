```julia
promote_op(f, argtypes...)
```

Guess what an appropriate container eltype would be for storing results of `f(::argtypes...)`. The guess is in part based on type inference, so can change any time.

Accordingly, return a type `R` such that `f(args...) isa R` where `args isa T`.

!!! warning
    Due to its fragility, use of `promote_op` should be avoided. It is preferable to base the container eltype on the type of the actual elements. Only in the absence of any elements (for an empty result container), it may be unavoidable to call `promote_op`.


The type `R` obtained from `promote_op` is merely an upper bound. There may exist a stricter type `S` such that `f(args...) isa S` for every `args isa T` with `S <: R` and `S != R`. Furthermore, the exact type `R` obtained from `promote_op` depends on various factors including but not limited to the exact Julia version used, packages loaded, and command line options. As such, when used in publicly registered packages, **it is the package authors' responsibility to ensure that the API guarantees provided by the package do not depend on the exact type `R` obtained from `promote_op`.**

Additionally, the result may return overly exact types, such as `DataType`, `Type`, or `Union{...}`, while the desired inputs or outputs may be different from those. The internal `promote_typejoin_union` function may be helpful to improve the result in some of these cases.

# Extended help

## Examples

The following function is an invalid use-case of `promote_op`.

```julia
"""
    invalid_usecase1(f, xs::AbstractArray) -> ys::Array

Return an array `ys` such that `vec(ys)` is `isequal`-equivalent to

    [f(xs[1]), f(xs[2]), ..., f(xs[end])]
"""
function invalid_usecase1(f, xs)
    R = promote_op(f, eltype(xs))
    ys = similar(xs, R)
    for i in eachindex(xs, ys)
        ys[i] = f(xs[i])
    end
    return ys
end
```

This is because the value obtained through `eltype(invalid_usecase1(f, xs))` depends on exactly what `promote_op` returns. It may be improved by re-computing the element type before returning the result.

```julia
function valid_usecase1(f, xs)
    R = promote_typejoin_union(promote_op(f, eltype(xs)))
    ys = similar(xs, R)
    S = Union{}
    for i in eachindex(xs, ys)
        ys[i] = f(xs[i])
        S = promote_type(S, typeof(ys[i]))
    end
    if S != R
        zs = similar(xs, S)
        copyto!(zs, ys)
        return zs
    end
    return ys
end
```

Note that using [`isconcretetype`](@ref) on the result is not enough to safely use `promote_op`. The following function is another invalid use-case of `promote_op`.

```julia
function invalid_usecase2(f, xs)
    R = promote_op(f, eltype(xs))
    if isconcretetype(R)
        ys = similar(xs, R)
    else
        ys = similar(xs, Any)
    end
    for i in eachindex(xs, ys)
        ys[i] = f(xs[i])
    end
    return ys
end
```

This is because whether or not the caller gets `Any` element type depends on if `promote_op` can infer a concrete return type of the given function. A fix similar to `valid_usecase1` can be used.

*Technically*, another possible fix for `invalid_usecase1` and `invalid_usecase2` is to loosen the API guarantee:

> ```
> another_valid_usecase1(f, xs::AbstractArray) -> ys::Array
> ```
>
> Return an array `ys` such that every element in `xs` with the same index is mapped with `f`.
>
> The element type of `ys` is *undefined*. It must not be used with generic functions whose behavior depend on the element type of `ys`.


However, it is discouraged to define such unconventional API guarantees.
