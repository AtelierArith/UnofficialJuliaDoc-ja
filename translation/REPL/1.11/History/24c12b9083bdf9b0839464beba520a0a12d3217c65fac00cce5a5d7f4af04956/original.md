```julia
filterchunkrev!(out, candidates, spec, idx; maxtime, maxresults) -> Int
```

Incrementally filter `candidates[1:idx]` in reverse order.

Pushes matches onto `out` until either `maxtime` is exceeded or `maxresults` collected, then returns the new resume index.
