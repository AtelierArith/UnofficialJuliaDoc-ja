```
=
```

`=` is the assignment operator.

  * For variable `a` and expression `b`, `a = b` makes `a` refer to the value of `b`.
  * For functions `f(x)`, `f(x) = x` defines a new function constant `f`, or adds a new method to `f` if `f` is already defined; this usage is equivalent to `function f(x); x; end`.
  * `a[i] = v` calls [`setindex!`](@ref)`(a,v,i)`.
  * `a.b = c` calls [`setproperty!`](@ref)`(a,:b,c)`.
  * Inside a function call, `f(a=b)` passes `b` as the value of keyword argument `a`.
  * Inside parentheses with commas, `(a=1,)` constructs a [`NamedTuple`](@ref).

# Examples

Assigning `a` to `b` does not create a copy of `b`; instead use [`copy`](@ref) or [`deepcopy`](@ref).

```jldoctest
julia> b = [1]; a = b; b[1] = 2; a
1-element Array{Int64, 1}:
 2

julia> b = [1]; a = copy(b); b[1] = 2; a
1-element Array{Int64, 1}:
 1

```

Collections passed to functions are also not copied. Functions can modify (mutate) the contents of the objects their arguments refer to. (The names of functions which do this are conventionally suffixed with '!'.)

```jldoctest
julia> function f!(x); x[:] .+= 1; end
f! (generic function with 1 method)

julia> a = [1]; f!(a); a
1-element Array{Int64, 1}:
 2

```

Assignment can operate on multiple variables in parallel, taking values from an iterable:

```jldoctest
julia> a, b = 4, 5
(4, 5)

julia> a, b = 1:3
1:3

julia> a, b
(1, 2)

```

Assignment can operate on multiple variables in series, and will return the value of the right-hand-most expression:

```jldoctest
julia> a = [1]; b = [2]; c = [3]; a = b = c
1-element Array{Int64, 1}:
 3

julia> b[1] = 2; a, b, c
([2], [2], [2])

```

Assignment at out-of-bounds indices does not grow a collection. If the collection is a [`Vector`](@ref) it can instead be grown with [`push!`](@ref) or [`append!`](@ref).

```jldoctest
julia> a = [1, 1]; a[3] = 2
ERROR: BoundsError: attempt to access 2-element Array{Int64, 1} at index [3]
[...]

julia> push!(a, 2, 3)
4-element Array{Int64, 1}:
 1
 1
 2
 3

```

Assigning `[]` does not eliminate elements from a collection; instead use [`filter!`](@ref).

```jldoctest
julia> a = collect(1:3); a[a .<= 1] = []
ERROR: DimensionMismatch: tried to assign 0 elements to 1 destinations
[...]

julia> filter!(x -> x > 1, a) # in-place & thus more efficient than a = a[a .> 1]
2-element Array{Int64, 1}:
 2
 3

```
