```julia
if/elseif/else
```

`if`/`elseif`/`else` performs conditional evaluation, which allows portions of code to be evaluated or not evaluated depending on the value of a boolean expression. Here is the anatomy of the `if`/`elseif`/`else` conditional syntax:

```julia
if x < y
    println("x is less than y")
elseif x > y
    println("x is greater than y")
else
    println("x is equal to y")
end
```

If the condition expression `x < y` is true, then the corresponding block is evaluated; otherwise the condition expression `x > y` is evaluated, and if it is true, the corresponding block is evaluated; if neither expression is true, the `else` block is evaluated. The `elseif` and `else` blocks are optional, and as many `elseif` blocks as desired can be used.

In contrast to some other languages conditions must be of type `Bool`. It does not suffice for conditions to be convertible to `Bool`.

```jldoctest
julia> if 1 end
ERROR: TypeError: non-boolean (Int64) used in boolean context
```
