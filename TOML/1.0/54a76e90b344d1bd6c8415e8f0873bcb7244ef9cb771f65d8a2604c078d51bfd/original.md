```
print([to_toml::Function], io::IO [=stdout], data::AbstractDict; sorted=false, by=identity, inline_tables::IdSet{<:AbstractDict})
```

Write `data` as TOML syntax to the stream `io`. If the keyword argument `sorted` is set to `true`, sort tables according to the function given by the keyword argument `by`. If the keyword argument `inline_tables` is given, it should be a set of tables that should be printed "inline".

The following data types are supported: `AbstractDict`, `AbstractVector`, `AbstractString`, `Integer`, `AbstractFloat`, `Bool`, `Dates.DateTime`, `Dates.Time`, `Dates.Date`. Note that the integers and floats need to be convertible to `Float64` and `Int64` respectively. For other data types, pass the function `to_toml` that takes the data types and returns a value of a supported type.
