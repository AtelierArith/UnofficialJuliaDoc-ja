```julia
Base.compilerbarrier(setting::Symbol, val)
```

This function acts a compiler barrier at a specified compilation phase. The dynamic semantics of this intrinsic are to return the `val` argument, unmodified. However, depending on the `setting`, the compiler is prevented from assuming this behavior.

Currently either of the following `setting`s is allowed:

  * Barriers on abstract interpretation:

      * `:type`: the return type of this function call will be inferred as `Any` always (the strongest barrier on abstract interpretation)
      * `:const`: the return type of this function call will be inferred with widening constant information on `val`
      * `:conditional`: the return type of this function call will be inferred with widening conditional information on `val` (see the example below)
  * Any barriers on optimization aren't implemented yet

!!! note
    This function is expected to be used with `setting` known precisely at compile-time. If the `setting` is not known precisely at compile-time, the compiler will emit the strongest barrier(s). No compile-time warning is issued.


# Examples

```julia
julia> Base.return_types((Int,)) do a
           x = compilerbarrier(:type, a) # `x` won't be inferred as `x::Int`
           return x
       end |> only
Any

julia> Base.return_types() do
           x = compilerbarrier(:const, 42)
           if x == 42 # no constant information here, so inference also accounts for the else branch
               return x # but `x` is still inferred as `x::Int` at least here
           else
               return nothing
           end
       end |> only
Union{Nothing, Int64}

julia> Base.return_types((Union{Int,Nothing},)) do a
           if compilerbarrier(:conditional, isa(a, Int))
               # the conditional information `a::Int` isn't available here (leading to less accurate return type inference)
               return a
           else
               return nothing
           end
       end |> only
Union{Nothing, Int64}
```
