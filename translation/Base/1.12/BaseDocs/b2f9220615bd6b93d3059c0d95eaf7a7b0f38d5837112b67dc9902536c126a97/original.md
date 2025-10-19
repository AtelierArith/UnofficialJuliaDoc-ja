```julia
let
```

`let` blocks create a new hard scope and optionally introduce new local bindings.

Just like the [other scope constructs](@ref man-scope-table), `let` blocks define the block of code where newly introduced local variables are accessible. Additionally, the syntax has a special meaning for comma-separated assignments and variable names that may optionally appear on the same line as the `let`:

```julia
let var1 = value1, var2, var3 = value3
    code
end
```

The variables introduced on this line are local to the `let` block and the assignments are evaluated in order, with each right-hand side evaluated in the scope without considering the name on the left-hand side. Therefore it makes sense to write something like `let x = x`, since the two `x` variables are distinct with the left-hand side locally shadowing the `x` from the outer scope. This can even be a useful idiom as new local variables are freshly created each time local scopes are entered, but this is only observable in the case of variables that outlive their scope via closures.  A `let` variable without an assignment, such as `var2` in the example above, declares a new local variable that is not yet bound to a value.

By contrast, [`begin`](@ref) blocks also group multiple expressions together but do not introduce scope or have the special assignment syntax.

### Examples

In the function below, there is a single `x` that is iteratively updated three times by the `map`. The closures returned all reference that one `x` at its final value:

```jldoctest
julia> function test_outer_x()
           x = 0
           map(1:3) do _
               x += 1
               return ()->x
           end
       end
test_outer_x (generic function with 1 method)

julia> [f() for f in test_outer_x()]
3-element Vector{Int64}:
 3
 3
 3
```

If, however, we add a `let` block that introduces a *new* local variable we will end up with three distinct variables being captured (one at each iteration) even though we chose to use (shadow) the same name.

```jldoctest
julia> function test_let_x()
           x = 0
           map(1:3) do _
               x += 1
               let x = x
                   return ()->x
               end
           end
       end
test_let_x (generic function with 1 method)

julia> [f() for f in test_let_x()]
3-element Vector{Int64}:
 1
 2
 3
```

All scope constructs that introduce new local variables behave this way when repeatedly run; the distinctive feature of `let` is its ability to succinctly declare new `local`s that may shadow outer variables of the same name. For example, directly using the argument of the `do` function similarly captures three distinct variables:

```jldoctest
julia> function test_do_x()
           map(1:3) do x
               return ()->x
           end
       end
test_do_x (generic function with 1 method)

julia> [f() for f in test_do_x()]
3-element Vector{Int64}:
 1
 2
 3
```
