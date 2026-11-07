```julia
reseteof(io)
```

Clear the EOF flag from IO so that further reads (and possibly writes) are again allowed. Note that it may immediately get re-set, if the underlying stream object is at EOF and cannot be resumed.
