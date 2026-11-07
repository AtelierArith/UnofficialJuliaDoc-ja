```julia
complex(T::Type)
```

Return an appropriate type which can represent a value of type `T` as a complex number. Equivalent to `typeof(complex(zero(T)))` if `T` does not contain `Missing`.

# Examples

```jldoctest
julia> complex(Complex{Int})
Complex{Int64}

julia> complex(Int)
Complex{Int64}

julia> complex(Union{Int, Missing})
Union{Missing, Complex{Int64}}
```
