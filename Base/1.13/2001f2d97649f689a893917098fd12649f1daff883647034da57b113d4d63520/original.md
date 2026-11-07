```julia
Base.get_bool_env(name::String, default::Bool; throw=false)::Union{Bool,Nothing}
Base.get_bool_env(f_default::Callable, name::String; throw=false)::Union{Bool,Nothing}
```

Evaluate whether the value of environment variable `name` is a truthy or falsy string, and return `nothing` (or throw if `throw=true`) if it is not recognized as either. If the variable is not set, or is set to "", return `default` or the result of executing `f_default()`.

Recognized values are the following, and their Capitalized and UPPERCASE forms:     truthy: "t", "true", "y", "yes", "1"     falsy:  "f", "false", "n", "no", "0"
