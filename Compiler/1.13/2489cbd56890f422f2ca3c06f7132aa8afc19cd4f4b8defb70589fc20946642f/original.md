```julia
ir_inline_unionsplit!
```

The primary purpose of this function is to emulate the dispatch behavior by generating flat `isa`-checks that correspond to the signatures of union-split dispatch candidates. These checks allow us to inline the method bodies into respective `isa`-conditional blocks.

Note that two pre-conditions are required for this emulation to work correctly:

1. Ordered Dispatch Candidates

The dispatch candidates must be processed in order of their specificity. The generated `isa`-checks should reflect this order, especially since the method signatures may not be concrete. For instance, with the methods:

```julia
f(x::Int)    = ...
f(x::Number) = ...
f(x::Any)    = ...
```

A correct `isa`-based dispatch emulation for the call site `f(x::Any)` would look like:

```julia
if isa(x, Int)
    [inlined/resolved f(x::Int)]
elseif isa(x, Number)
    [inlined/resolved f(x::Number)]
else
    [inlined/resolved f(x::Any)]
end
```

`ml_matches` should already sort the matched method candidates correctly, except in ambiguous cases, which we've already excluded at this state.

2. Type Equality Constraints

Another factor is the type equality constraint imposed by type variables. Simple `isa`-checks are insufficient to capture the semantics in some cases. For example, given the following method definition:

```julia
g(x::T, y::T) where T<:Integer = ...
```

it is *invalid* to optimize a cal site like `g(x::Any, y::Any)` into:

```julia
if isa(x, Integer) && isa(y, Integer)
    [inlined/resolved g(x::Integer, y::Integer)]
else
    g(x, y) # fallback dynamic dispatch
end
```

since we also need to check that `x` and `y` are equal types.

But, we've already excluded such cases at this point, mainly by filtering out `case.sig::UnionAll`, so there is no need to worry about type equality at this point.

In essence, we can process the dispatch candidates sequentially, assuming their order stays the same post-discovery in `ml_matches`.
