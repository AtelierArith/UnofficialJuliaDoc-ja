```
ssh_known_hosts_file() :: String
```

The `ssh_known_hosts_file()` function returns a single path of an SSH known hosts file that should be used when establishing the identities of remote servers for SSH connections. It returns the first path returned by `ssh_known_hosts_files` that actually exists. Callers who can look in more than one known hosts file should use `ssh_known_hosts_files` instead and look for host matches in all the files returned as described in that function's docs.
