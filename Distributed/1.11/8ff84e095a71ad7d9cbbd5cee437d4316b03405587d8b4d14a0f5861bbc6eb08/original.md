```
fetch(c::RemoteChannel)
```

Wait for and get a value from a [`RemoteChannel`](@ref). Exceptions raised are the same as for a [`Future`](@ref). Does not remove the item fetched.
