```
parse_pidfile(file::Union{IO, String}) => (pid, hostname, age)
```

Attempt to parse our pidfile format, replaced an element with (0, "", 0.0), respectively, for any read that failed.
