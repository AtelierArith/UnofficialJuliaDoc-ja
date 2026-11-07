```julia
fetch(t::Task)
```

Wait for a [`Task`](@ref) to finish, then return its result value. If the task fails with an exception, a [`TaskFailedException`](@ref) (which wraps the failed task) is thrown.
