```
Main
```

`Main` is the top-level module, and Julia starts with `Main` set as the current module.  Variables defined at the prompt go in `Main`, and `varinfo` lists variables in `Main`.

```jldoctest
julia> @__MODULE__
Main
```
