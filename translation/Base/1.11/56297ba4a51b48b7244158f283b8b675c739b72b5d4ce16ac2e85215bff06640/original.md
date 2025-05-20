```
Base.@constprop setting [ex]
```

Control the mode of interprocedural constant propagation for the annotated function.

Two `setting`s are supported:

  * `Base.@constprop :aggressive [ex]`: apply constant propagation aggressively. For a method where the return type depends on the value of the arguments, this can yield improved inference results at the cost of additional compile time.
  * `Base.@constprop :none [ex]`: disable constant propagation. This can reduce compile times for functions that Julia might otherwise deem worthy of constant-propagation. Common cases are for functions with `Bool`- or `Symbol`-valued arguments or keyword arguments.

`Base.@constprop` can be applied immediately before a function definition or within a function body.

```julia
# annotate long-form definition
Base.@constprop :aggressive function longdef(x)
    ...
end

# annotate short-form definition
Base.@constprop :aggressive shortdef(x) = ...

# annotate anonymous function that a `do` block creates
f() do
    Base.@constprop :aggressive
    ...
end
```

!!! compat "Julia 1.10"
    The usage within a function body requires at least Julia 1.10.

