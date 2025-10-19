```julia
ssh_pub_key_path() :: String
```

The `ssh_pub_key_path()` function returns the path of the SSH public key file that should be used for SSH connections. If the `SSH_PUB_KEY_PATH` environment variable is set then it will return that value. If that isn't set but `SSH_KEY_PATH` is set, it will return that path with the `.pub` suffix appended. If neither is set, it defaults to returning

```julia
joinpath(ssh_dir(), ssh_key_name() * ".pub")
```

This default value in turn depends on the `SSH_DIR` and `SSH_KEY_NAME` environment variables.
