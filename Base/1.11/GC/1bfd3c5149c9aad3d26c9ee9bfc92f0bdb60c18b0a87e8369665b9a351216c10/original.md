```
GC.enable(on::Bool)
```

Control whether garbage collection is enabled using a boolean argument (`true` for enabled, `false` for disabled). Return previous GC state.

!!! warning
    Disabling garbage collection should be used only with caution, as it can cause memory use to grow without bound.

