```julia
Base.drop_all_caches()
```

Internal function to drop all native code caches and increment world age. This invalidates all compiled code as if a method was added that intersects with all existing methods.
