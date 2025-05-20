```
mktemp(f::Function, parent=tempdir())
```

Apply the function `f` to the result of [`mktemp(parent)`](@ref) and remove the temporary file upon completion.

See also: [`mktempdir`](@ref).
