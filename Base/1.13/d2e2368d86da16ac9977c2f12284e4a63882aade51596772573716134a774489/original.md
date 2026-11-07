```julia
retry_load_extensions()
```

Loads all the (not yet loaded) extensions that have their extension-dependencies loaded. This is used in cases where the automatic loading of an extension failed due to some problem with the extension. Instead of restarting the Julia session, the extension can be fixed, and this function run.
