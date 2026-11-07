```julia
@ncall N f sym...
```

Generate a function call expression. `sym` represents any number of function arguments, the last of which may be an anonymous-function expression and is expanded into `N` arguments.

For example, `@ncall 3 func a` generates

```julia
func(a_1, a_2, a_3)
```

while `@ncall 2 func a b i->c[i]` yields

```julia
func(a, b, c[1], c[2])
```
