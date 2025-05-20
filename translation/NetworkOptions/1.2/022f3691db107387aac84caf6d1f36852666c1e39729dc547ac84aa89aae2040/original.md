```
ssh_known_hosts_files() :: Vector{String}
```

The `ssh_known_hosts_files()` function returns a vector of paths of SSH known hosts files that should be used when establishing the identities of remote servers for SSH connections. By default this function returns

```
[joinpath(ssh_dir(), "known_hosts"), bundled_known_hosts]
```

where `bundled_known_hosts` is the path of a copy of a known hosts file that is bundled with this package (containing known hosts keys for `github.com` and `gitlab.com`). If the environment variable `SSH_KNOWN_HOSTS_FILES` is set, however, then its value is split into paths on the `:` character (or on `;` on Windows) and this vector of paths is returned instead. If any component of this vector is empty, it is expanded to the default known hosts paths.

Packages that use `ssh_known_hosts_files()` should ideally look for matching entries by comparing the host name and key types, considering the first entry in any of the files which matches to be the definitive identity of the host. If the caller cannot compare the key type (e.g. because it has been hashes) then it must approximate the above algorithm by looking for all matching entries for a host in each file: if a file has any entries for a host then one of them must match; the caller should only continue to search further known hosts files if there are no entries for the host in question in an earlier file.
