```julia
devnull
```

Used in a stream redirect to discard all data written to it. Essentially equivalent to `/dev/null` on Unix or `NUL` on Windows. Usage:

```julia
run(pipeline(`cat test.txt`, devnull))
```
