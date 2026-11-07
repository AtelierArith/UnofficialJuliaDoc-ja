```julia
effects::Effects
```

Represents computational effects of a method call.

The effects are a composition of different effect bits that represent some program property of the method being analyzed. They are represented as `Bool` or `UInt8` bits with the following meanings:

  * `consistent::UInt8`:

      * `ALWAYS_TRUE`: this method is guaranteed to return or terminate consistently.
      * `ALWAYS_FALSE`: this method may be not return or terminate consistently, and there is no need for further analysis with respect to this effect property as this conclusion will not be refined anyway.
      * `CONSISTENT_IF_NOTRETURNED`: the `:consistent`-cy of this method can later be refined to `ALWAYS_TRUE` in a case when the return value of this method never involves newly allocated mutable objects.
      * `CONSISTENT_IF_INACCESSIBLEMEMONLY`: the `:consistent`-cy of this method can later be refined to `ALWAYS_TRUE` in a case when `:inaccessiblememonly` is proven.
  * `effect_free::UInt8`:

      * `ALWAYS_TRUE`: this method is free from externally semantically visible side effects.
      * `ALWAYS_FALSE`: this method may not be free from externally semantically visible side effects, and there is no need for further analysis with respect to this effect property as this conclusion will not be refined anyway.
      * `EFFECT_FREE_IF_INACCESSIBLEMEMONLY`: the `:effect-free`-ness of this method can later be refined to `ALWAYS_TRUE` in a case when `:inaccessiblememonly` is proven.
  * `nothrow::Bool`: this method is guaranteed to not throw an exception. If the execution of this method may raise `MethodError`s and similar exceptions, then the method is not considered as `:nothrow`. However, note that environment-dependent errors like `StackOverflowError` or `InterruptException` are not modeled by this effect and thus a method that may result in `StackOverflowError` does not necessarily need to taint `:nothrow` (although it should usually taint `:terminates` too).
  * `terminates::Bool`: this method is guaranteed to terminate.
  * `notaskstate::Bool`: this method does not access any state bound to the current task and may thus be moved to a different task without changing observable behavior. Note that this currently implies that `noyield` as well, since yielding modifies the state of the current task, though this may be split in the future.
  * `inaccessiblememonly::UInt8`:

      * `ALWAYS_TRUE`: this method does not access or modify externally accessible mutable memory. This state corresponds to LLVM's `inaccessiblememonly` function attribute.
      * `ALWAYS_FALSE`: this method may access or modify externally accessible mutable memory.
      * `INACCESSIBLEMEM_OR_ARGMEMONLY`: this method does not access or modify externally accessible mutable memory, except that it may access or modify mutable memory pointed to by its call arguments. This may later be refined to `ALWAYS_TRUE` in a case when call arguments are known to be immutable. This state corresponds to LLVM's `inaccessiblemem_or_argmemonly` function attribute.
  * `noub::UInt8`:

      * `ALWAYS_TRUE`: this method is guaranteed to not execute any undefined behavior (for any input).
      * `ALWAYS_FALSE`: this method may execute undefined behavior.
      * `NOUB_IF_NOINBOUNDS`: this method is guaranteed to not execute any undefined behavior under the assumption that its `@boundscheck` code is not elided (which happens when the caller does not set nor propagate the `@inbounds` context)

    Note that undefined behavior may technically cause the method to violate any other effect assertions (such as `:consistent` or `:effect_free`) as well, but we do not model this, and they assume the absence of undefined behavior.
  * `nonoverlayed::UInt8`:

      * `ALWAYS_TRUE`: this method is guaranteed to not invoke any methods that defined in an [overlayed method table](@ref OverlayMethodTable).
      * `CONSISTENT_OVERLAY`: this method may invoke overlayed methods, but all such overlayed methods are `:consistent` with their non-overlayed original counterparts (see [`Base.@assume_effects`](@ref) for the exact definition of `:consistenct`-cy).
      * `ALWAYS_FALSE`: this method may invoke overlayed methods.
  * `nortcall::Bool`: this method does not call `Core.Compiler.return_type`, and it is guaranteed that any other methods this method might call also do not call `Core.Compiler.return_type`.

Note that the representations above are just internal implementation details and thus likely to change in the future. See [`Base.@assume_effects`](@ref) for more detailed explanation on the definitions of these properties.

Along the abstract interpretation, `Effects` at each statement are analyzed locally and they are merged into the single global `Effects` that represents the entire effects of the analyzed method (see the implementation of `merge_effects!`). Each effect property is initialized with `ALWAYS_TRUE`/`true` and then transitioned towards `ALWAYS_FALSE`/`false`. Note that within the current flow-insensitive analysis design, effects detected by local analysis on each statement usually taint the global conclusion conservatively.

## Key for `show` output of Effects:

The output represents the state of different effect properties in the following order:

1. `consistent` (`c`):

      * `+c` (green): `ALWAYS_TRUE`
      * `-c` (red): `ALWAYS_FALSE`
      * `?c` (yellow): `CONSISTENT_IF_NOTRETURNED` and/or `CONSISTENT_IF_INACCESSIBLEMEMONLY`
2. `effect_free` (`e`):

      * `+e` (green): `ALWAYS_TRUE`
      * `-e` (red): `ALWAYS_FALSE`
      * `?e` (yellow): `EFFECT_FREE_IF_INACCESSIBLEMEMONLY`
3. `nothrow` (`n`):

      * `+n` (green): `true`
      * `-n` (red): `false`
4. `terminates` (`t`):

      * `+t` (green): `true`
      * `-t` (red): `false`
5. `notaskstate` (`s`):

      * `+s` (green): `true`
      * `-s` (red): `false`
6. `inaccessiblememonly` (`m`):

      * `+m` (green): `ALWAYS_TRUE`
      * `-m` (red): `ALWAYS_FALSE`
      * `?m` (yellow): `INACCESSIBLEMEM_OR_ARGMEMONLY`
7. `noub` (`u`):

      * `+u` (green): `true`
      * `-u` (red): `false`
      * `?u` (yellow): `NOUB_IF_NOINBOUNDS`
8. `:nonoverlayed` (`o`):

      * `+o` (green): `ALWAYS_TRUE`
      * `-o` (red): `ALWAYS_FALSE`
      * `?o` (yellow): `CONSISTENT_OVERLAY`
9. `:nortcall` (`r`):

      * `+r` (green): `true`
      * `-r` (red): `false`
