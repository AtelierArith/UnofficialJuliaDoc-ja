```
load_customisations!(; force::Bool=false)
```

Load customisations from the user's `faces.toml` file, if it exists as well as the current environment.

This function should be called before producing any output in situations where the user's customisations should be considered. This is called automatically when printing text or HTML output, and when calling `withfaces`, but may need to be called manually in unusual situations.

Unless `force` is set, customisations are only applied when this function is called for the first time, and subsequent calls are a no-op.
