```
f ∘ g
```

Compose functions: i.e. `(f ∘ g)(args...; kwargs...)` means `f(g(args...; kwargs...))`. The `∘` symbol can be entered in the Julia REPL (and most editors, appropriately configured) by typing `\circ<tab>`.

Function composition also works in prefix form: `∘(f, g)` is the same as `f ∘ g`. The prefix form supports composition of multiple functions: `∘(f, g, h) = f ∘ g ∘ h` and splatting `∘(fs...)` for composing an iterable collection of functions. The last argument to `∘` execute first.

!!! compat "Julia 1.4"
    Multiple function composition requires at least Julia 1.4.


!!! compat "Julia 1.5"
    Composition of one function ∘(f) requires at least Julia 1.5.


!!! compat "Julia 1.7"
    Using keyword arguments requires at least Julia 1.7.


# Examples

```jldoctest
julia> map(uppercase∘first, ["apple", "banana", "carrot"])
3-element Vector{Char}:
 'A': ASCII/Unicode U+0041 (category Lu: Letter, uppercase)
 'B': ASCII/Unicode U+0042 (category Lu: Letter, uppercase)
 'C': ASCII/Unicode U+0043 (category Lu: Letter, uppercase)

julia> (==(6)∘length).(["apple", "banana", "carrot"])
3-element BitVector:
 0
 1
 1

julia> fs = [
           x -> 2x
           x -> x-1
           x -> x/2
           x -> x+1
       ];

julia> ∘(fs...)(3)
2.0
```

See also [`ComposedFunction`](@ref), [`!f::Function`](@ref).
