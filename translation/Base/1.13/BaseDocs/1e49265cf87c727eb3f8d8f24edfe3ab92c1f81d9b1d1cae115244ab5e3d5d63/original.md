```julia
finally
```

Run some code when a given `try` block of code exits, regardless of how it exits. For example, here is how we can guarantee that an opened file is closed:

```julia
f = open("file")
try
    operate_on_file(f)
finally
    close(f)
end
```

When control leaves the [`try`](@ref) block (for example, due to a [`return`](@ref), or just finishing normally), [`close(f)`](@ref) will be executed. If the `try` block exits due to an exception, the exception will continue propagating. A `catch` block may be combined with `try` and `finally` as well. In this case the `finally` block will run after `catch` has handled the error.

When evaluating a `try/catch/else/finally` expression, the value of the entire expression is the value of the last block executed, excluding the `finally` block. For example:

```jldoctest
julia> try
           1
       finally
           2
       end
1

julia> try
           error("")
       catch
           1
       else
           2
       finally
           3
       end
1

julia> try
           0
       catch
           1
       else
           2
       finally
           3
       end
2
```
