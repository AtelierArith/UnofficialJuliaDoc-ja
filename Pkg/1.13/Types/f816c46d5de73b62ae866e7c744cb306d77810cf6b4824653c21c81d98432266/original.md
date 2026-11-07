```julia
manifest_format_for(julia_version)
```

The manifest format that the Pkg of `julia_version` writes, the newest one for `nothing`. A newer Julia than this one may write a newer format, which this Pkg cannot know, so it gets this Pkg's format.
