```julia
Base.Experimental.@overlay mt def
Base.Experimental.@overlay mt begin defs... end
```

Define a method and add it to the method table `mt` instead of to the global method table. This can be used to implement a method override mechanism. Regular compilation will not consider these methods, and you should customize the compilation flow to look in these method tables (e.g., using [`Core.Compiler.OverlayMethodTable`](@ref)). The block form overlays every definition in the block; definitions may carry docstrings and other macros.

!!! note
    Please be aware that when defining overlay methods using `@overlay`, it is not necessary to have an original method that corresponds exactly in terms of how the method dispatches. This means that the method overlay mechanism enabled by `@overlay` is not implemented by replacing the methods themselves, but through an additional and prioritized method lookup during the method dispatch.

    Considering this, it is important to understand that in compilations using an overlay method table like the following, the method dispatched by `callx(x)` is not the regular method `callx(::Float64)`, but the overlay method `callx(x::Real)`:

    ```julia
    callx(::Real) = :real
    @overlay SOME_OVERLAY_MT callx(::Real) = :overlay_real
    callx(::Float64) = :float64

    # some overlay callsite
    let x::Float64
        callx(x) #> :overlay_real
    end
    ```

