```julia
propertynames(x, private=false)
```

Get a tuple or a vector of the properties (`x.property`) of an object `x`. This is typically the same as [`fieldnames(typeof(x))`](@ref), but types that overload [`getproperty`](@ref) should generally overload `propertynames` as well to get the properties of an instance of the type.

`propertynames(x)` may return only "public" property names that are part of the documented interface of `x`.   If you want it to also return "private" property names intended for internal use, pass `true` for the optional second argument. REPL tab completion on `x.` shows only the `private=false` properties.

See also: [`hasproperty`](@ref), [`hasfield`](@ref).
