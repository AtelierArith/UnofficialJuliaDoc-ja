```
undocumented_names(mod::Module; private=false)
```

Return a sorted vector of undocumented symbols in `module` (that is, lacking docstrings). `private=false` (the default) returns only identifiers declared with `public` and/or `export`, whereas `private=true` returns all symbols in the module (excluding compiler-generated hidden symbols starting with `#`).

See also: [`names`](@ref), [`Docs.hasdoc`](@ref), [`Base.ispublic`](@ref).
