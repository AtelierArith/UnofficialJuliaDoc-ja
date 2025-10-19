```julia
@inline
```

Give a hint to the compiler that this function is worth inlining.

Small functions typically do not need the `@inline` annotation, as the compiler does it automatically. By using `@inline` on bigger functions, an extra nudge can be given to the compiler to inline it.

`@inline` can be applied immediately before a function definition or within a function body.

```julia
# annotate long-form definition
@inline function longdef(x)
    ...
end

# annotate short-form definition
@inline shortdef(x) = ...

# annotate anonymous function that a `do` block creates
f() do
    @inline
    ...
end
```

!!! compat "Julia 1.8"
    The usage within a function body requires at least Julia 1.8.


---

```julia
@inline block
```

Give a hint to the compiler that calls within `block` are worth inlining.

```julia
# The compiler will try to inline `f`
@inline f(...)

# The compiler will try to inline `f`, `g` and `+`
@inline f(...) + g(...)
```

!!! note
    A callsite annotation always has the precedence over the annotation applied to the definition of the called function:

    ```julia
    @noinline function explicit_noinline(args...)
        # body
    end

    let
        @inline explicit_noinline(args...) # will be inlined
    end
    ```


!!! note
    When there are nested callsite annotations, the innermost annotation has the precedence:

    ```julia
    @noinline let a0, b0 = ...
        a = @inline f(a0)  # the compiler will try to inline this call
        b = f(b0)          # the compiler will NOT try to inline this call
        return a, b
    end
    ```


!!! warning
    Although a callsite annotation will try to force inlining in regardless of the cost model, there are still chances it can't succeed in it. Especially, recursive calls can not be inlined even if they are annotated as `@inline`d.


!!! compat "Julia 1.8"
    The callsite annotation requires at least Julia 1.8.

