```julia
ca_roots_path() :: String
```

The `ca_roots_path()` function is similar to the `ca_roots()` function except that it always returns a path to a file or directory of PEM-encoded certificate authority roots. When called on a system like Windows or macOS, where system root certificates are not stored in the file system, it will currently return the path to the set of root certificates that are bundled with Julia. (In the future, this function may instead extract the root certificates from the system and save them to a file whose path would be returned.)

If it is possible to configure a library that uses TLS to use the system certificates that is generally preferable: i.e. it is better to use `ca_roots()` which returns `nothing` to indicate that the system certs should be used. The `ca_roots_path()` function should only be used when configuring libraries which *require* a path to a file or directory for root certificates.

The default value returned by `ca_roots_path()` may be overridden by setting the `JULIA_SSL_CA_ROOTS_PATH`, `SSL_CERT_DIR`, or `SSL_CERT_FILE` environment variables, in which case this function will always return the value of the first of these variables that is set (whether the path exists or not). If `JULIA_SSL_CA_ROOTS_PATH` is set to the empty string, then the other variables are ignored (as if unset); if the other variables are set to the empty string, they behave is if they are not set.
