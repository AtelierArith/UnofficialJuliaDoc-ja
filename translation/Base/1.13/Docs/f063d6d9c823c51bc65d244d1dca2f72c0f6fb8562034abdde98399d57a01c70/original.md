```julia
Docs.metadata(source, module, expr, ismodule)
```

Build a `Dict` expression containing metadata captured from the expression `expr`.

Fields that may be included in the returned `Dict`:

  * `:path`:       Symbol representing the file where `expr` is defined.
  * `:linenumber`: Linenumber where `expr` is defined.
  * `:module`:     Module where the docstring is defined.
  * `:fields`:     `Dict` of all field docs found in `expr`. Only for concrete types.
