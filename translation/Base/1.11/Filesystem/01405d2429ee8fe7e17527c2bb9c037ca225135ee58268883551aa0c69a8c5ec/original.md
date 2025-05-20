```
S_IRUSR
S_IWUSR
S_IXUSR
S_IRGRP
S_IWGRP
S_IXGRP
S_IROTH
S_IWOTH
S_IXOTH
```

Constants for file access permission bits. The general structure is `S_I[permission][class]` where `permission` is `R` for read, `W` for write, and `X` for execute, and `class` is `USR` for user/owner, `GRP` for group, and `OTH` for other.
