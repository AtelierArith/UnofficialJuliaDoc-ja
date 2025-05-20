```
export
```

`export` is used within modules to tell Julia which names should be made available to the user. For example: `export foo` makes the name `foo` available when [`using`](@ref) the module. See the [manual section about modules](@ref modules) for details.
