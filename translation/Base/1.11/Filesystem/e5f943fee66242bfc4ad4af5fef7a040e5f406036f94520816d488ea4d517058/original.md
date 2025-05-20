```
abspath(path::AbstractString) -> String
```

Convert a path to an absolute path by adding the current directory if necessary. Also normalizes the path as in [`normpath`](@ref).

# Examples

If you are in a directory called `JuliaExample` and the data you are using is two levels up relative to the `JuliaExample` directory, you could write:

```
abspath("../../data")
```

Which gives a path like `"/home/JuliaUser/data/"`.

See also [`joinpath`](@ref), [`pwd`](@ref), [`expanduser`](@ref).
