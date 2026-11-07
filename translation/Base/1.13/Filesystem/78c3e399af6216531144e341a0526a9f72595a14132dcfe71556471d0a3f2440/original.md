```julia
S_IRWXU
S_IRWXG
S_IRWXO
```

Constants for file access permission masks, i.e. the combination of read, write, and execute permissions for a class. The general structure is `S_IRWX[class]` where `class` is `U` for user/owner, `G` for group, and `O` for other.
