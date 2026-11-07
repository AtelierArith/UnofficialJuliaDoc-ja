```julia
lbt_find_backing_library(symbol_name, interface; config::LBTConfig = lbt_get_config())
```

Return the `LBTLibraryInfo` that represents the backing library for the given symbol exported from libblastrampoline.  This allows us to discover which library will service a particular BLAS call from Julia code.  This method returns `nothing` if either of the following conditions are met:

  * No loaded library exports the desired symbol (the default function will be called)
  * The symbol was set via `lbt_set_forward()`, which does not track library provenance.

If the given `symbol_name` is not contained within the list of exported symbols, an `ArgumentError` will be thrown.
