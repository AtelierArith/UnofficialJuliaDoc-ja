```julia
Base.Experimental.@consistent_overlay mt def
```

This macro operates almost identically to [`Base.Experimental.@overlay`](@ref), defining a new overlay method. The key difference with this macro is that it informs the compiler that the invocation of the overlay method it defines is `:consistent` with a regular, non-overlayed method call.

More formally, when evaluating a generic function call ``f(x)`` at a specific world age ``i``, if a regular method call ``fᵢ(x)`` is redirected to an overlay method call ``fᵢ′(x)`` defined by this macro, ``fᵢ(x)`` and ``fᵢ′(x)`` are considered `:consistent` if the following conditions are met:

  * If ``fᵢ(x)`` returns a value ``y``, then ``fᵢ′(x)`` also returns some value ``yᵢ``, and ``y ≡ yᵢ`` holds.
  * If ``fᵢ(x)`` throws an exception, then ``fᵢ′(x)`` also throws some exception.

For a detailed definition of `:consistent`-cy, consult the corresponding section in [`Base.@assume_effects`](@ref).

!!! note
    Note that the requirements for `:consistent`-cy include not only that the return values are egal, but also that the manner of termination is the same. However, it's important to aware that when they throw exceptions, the exceptions themselves don't necessarily have to be egal. In other words, if ``fᵢ(x)`` throws an exception, ``fᵢ′(x)`` is required to also throw one, but the exact exceptions may differ.


!!! note
    Please note that the `:consistent`-cy requirement applies not to method itself but to *method invocation*. This means that for the use of `@consistent_overlay`, it is necessary for method invocations with the native regular compilation and those with a compilation with overlay method table to be `:consistent`.

    For example, it is important to understand that, `@consistent_overlay` can be used like the following:

    ```julia
    callsin(x::Real) = x < 0 ? error(x) : sin(x)
    @consistent_overlay SOME_OVERLAY_MT callsin(x::Float64) =
        x < 0 ? error_somehow(x) : sin(x)
    ```

    However, be aware that this `@consistent_overlay` will immediately become invalid if a new method for `callsin` is defined subsequently, such as:

    ```julia
    callsin(x::Float64) = cos(x)
    ```

    This specifically implies that the use of `@consistent_overlay` should be restricted as much as possible to cases where a regular method with a concrete signature is replaced by an overlay method with the same concrete signature.

    This constraint is closely related to the note in [`Base.Experimental.@overlay`](@ref); you are advised to consult that as well.

