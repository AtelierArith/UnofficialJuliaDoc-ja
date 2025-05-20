```
TaskLocalRNG
```

The `TaskLocalRNG` has state that is local to its task, not its thread. It is seeded upon task creation, from the state of its parent task, but without advancing the state of the parent's RNG.

As an upside, the `TaskLocalRNG` is pretty fast, and permits reproducible multithreaded simulations (barring race conditions), independent of scheduler decisions. As long as the number of threads is not used to make decisions on task creation, simulation results are also independent of the number of available threads / CPUs. The random stream should not depend on hardware specifics, up to endianness and possibly word size.

Using or seeding the RNG of any other task than the one returned by `current_task()` is undefined behavior: it will work most of the time, and may sometimes fail silently.

When seeding `TaskLocalRNG()` with [`seed!`](@ref), the passed seed, if any, may be any integer.

!!! compat "Julia 1.11"
    Seeding `TaskLocalRNG()` with a negative integer seed requires at least Julia 1.11.


!!! compat "Julia 1.10"
    Task creation no longer advances the parent task's RNG state as of Julia 1.10.

