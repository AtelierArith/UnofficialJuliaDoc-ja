```
@noinline
```

Give a hint to the compiler that it should not inline a function.

Small functions are typically inlined automatically. By using `@noinline` on small functions, auto-inlining can be prevented.

`@noinline` can be applied immediately before a function definition or within a function body.

```julia
# annotate long-form definition
@noinline function longdef(x)
    ...
end

# annotate short-form definition
@noinline shortdef(x) = ...

# annotate anonymous function that a `do` block creates
f() do
    @noinline
    ...
end
```

!!! compat "Julia 1.8"
    The usage within a function body requires at least Julia 1.8.


---

```
@noinline block
```

Give a hint to the compiler that it should not inline the calls within `block`.

```julia
# The compiler will try to not inline `f`
@noinline f(...)

# The compiler will try to not inline `f`, `g` and `+`
@noinline f(...) + g(...)
```

!!! note
    A callsite annotation always has the precedence over the annotation applied to the definition of the called function:

    ```julia
    @inline function explicit_inline(args...)
        # body
    end

    let
        @noinline explicit_inline(args...) # will not be inlined
    end
    ```


!!! note
    When there are nested callsite annotations, the innermost annotation has the precedence:

    ```julia
    @inline let a0, b0 = ...
        a = @noinline f(a0)  # the compiler will NOT try to inline this call
        b = f(b0)            # the compiler will try to inline this call
        return a, b
    end
    ```


!!! compat "Julia 1.8"
    The callsite annotation requires at least Julia 1.8.


---

!!! note
    If the function is trivial (for example returning a constant) it might get inlined anyway.

