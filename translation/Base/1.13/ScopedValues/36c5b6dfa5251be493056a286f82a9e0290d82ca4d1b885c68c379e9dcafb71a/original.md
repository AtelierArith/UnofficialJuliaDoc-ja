```julia
LazyScopedValue{T}(f::OncePerProcess{T})
```

A scoped value that uses an `OncePerProcess{T}` to lazily compute its default value when none has been set in the current scope. Unlike `ScopedValue`, the default is not evaluated at construction time but only when first accessed.

# Examples

```julia-repl
julia> using Base.ScopedValues;

julia> const editor = LazyScopedValue(OncePerProcess(() -> ENV["JULIA_EDITOR"]));

julia> editor[]
"vim"

julia> with(editor => "emacs") do
           sval[]
       end
"emacs"

julia> editor[]
"vim"
```

!!! compat "Julia 1.13"
    LazyScopedValue requires Julia 1.13+.

