```
@which
```

Applied to a function or macro call, it evaluates the arguments to the specified call, and returns the `Method` object for the method that would be called for those arguments. Applied to a variable, it returns the module in which the variable was bound. It calls out to the [`which`](@ref) function.

See also: [`@less`](@ref), [`@edit`](@ref).
