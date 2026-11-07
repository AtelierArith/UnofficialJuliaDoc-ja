```julia
replace_sourceloc!(location, expr)
```

Overwrite the caller source location for each macro call in `expr`, returning the resulting AST.  This is useful when you need to wrap a macro inside a macro, and want the inner macro to see the `__source__` location of the outer macro.  For example:

```julia
macro test_is_one(ex)
    replace_sourceloc!(__source__, :(@test $(esc(ex)) == 1))
end
@test_is_one 2
```

`@test` now reports the location of the call `@test_is_one 2` to the user, rather than line 2 where `@test` is used as an implementation detail.
