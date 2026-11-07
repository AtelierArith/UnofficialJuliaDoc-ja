```julia
complex(T::Type)
```

`T` 型の値を複素数として表現できる、適切な型を返します。`T` に `Missing` が含まれていない場合は、`typeof(complex(zero(T)))` と同等です。

# Examples

```jldoctest
julia> complex(Complex{Int})
Complex{Int64}

julia> complex(Int)
Complex{Int64}

julia> complex(Union{Int, Missing})
Union{Missing, Complex{Int64}}
```
