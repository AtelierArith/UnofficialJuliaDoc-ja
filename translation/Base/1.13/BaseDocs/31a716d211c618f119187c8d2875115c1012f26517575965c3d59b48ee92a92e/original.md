```julia
ConcurrencyViolationError(msg) <: Exception
```

An error thrown when a detectable violation of concurrent semantics has occurred.

A non-exhaustive list of examples of when this is used include:

  * Throwing when a deadlock has been detected (e.g. `wait(current_task())`)
  * Known-unsafe behavior is attempted (e.g. `yield(current_task)`)
  * A known non-threadsafe datastructure is attempted to be modified from multiple concurrent tasks
  * A lock is being unlocked that wasn't locked by this task
