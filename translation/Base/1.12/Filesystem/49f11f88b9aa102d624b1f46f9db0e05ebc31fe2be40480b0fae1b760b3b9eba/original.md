```julia
ischardev(path) -> Bool
ischardev(path_elements...) -> Bool
ischardev(stat_struct) -> Bool
```

Return `true` if the path `path` or file descriptor `stat_struct` refer to a character device, `false` otherwise.
