```
ssh_key_pass() :: String
```

The `ssh_key_pass()` function returns the value of the environment variable `SSH_KEY_PASS` if it is set or `nothing` if it is not set. In the future, this may be able to find a password by other means, such as secure system storage, so packages that need a password to decrypt an SSH private key should use this API instead of directly checking the environment variable so that they gain such capabilities automatically when they are added.
