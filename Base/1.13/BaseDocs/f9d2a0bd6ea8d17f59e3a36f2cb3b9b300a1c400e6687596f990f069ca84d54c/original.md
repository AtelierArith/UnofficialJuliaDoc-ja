_import(to::Module, from::Module, asname::Symbol, [sym::Symbol, imported::Bool])

With all five arguments, imports `sym` from module `from` into `to` with name `asname`.  `imported` is true for bindings created with `import` (set it to false for `using A: ...`).

With only the first three arguments, creates a binding for the module `from` with name `asname` in `to`.
