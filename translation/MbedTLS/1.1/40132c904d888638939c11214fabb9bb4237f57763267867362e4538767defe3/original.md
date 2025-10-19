```julia
isopen(ctx::SSLContext)
```

Same as `iswritable(ctx)`.

> "...a closed stream may still have data to read in its buffer,  use eof to check for the ability to read data." [?Base.isopen]

