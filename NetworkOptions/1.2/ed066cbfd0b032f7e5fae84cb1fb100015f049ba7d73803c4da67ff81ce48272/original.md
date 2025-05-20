```
ssh_key_path() :: String
```

The `ssh_key_path()` function returns the path of the SSH private key file that should be used for SSH connections. If the `SSH_KEY_PATH` environment variable is set then it will return that value. Otherwise it defaults to returning

```
joinpath(ssh_dir(), ssh_key_name())
```

This default value in turn depends on the `SSH_DIR` and `SSH_KEY_NAME` environment variables.
