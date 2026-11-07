```julia
mv_temp_dir_retries(temp_dir::String, new_path::String; set_permissions::Bool=true)::Nothing
```

Either rename the directory at `temp_dir` to `new_path` and set it to read-only or if `new_path` already exists try to do nothing. Both `temp_dir` and `new_path` must be on the same filesystem.
