```julia
@profile_walltime
```

`@profile_walltime <expression>` runs your expression while taking periodic backtraces of a sample of all live tasks (both running and not running). These are appended to an internal buffer of backtraces.

It can be configured via `Profile.init`, same as the `Profile.@profile`, and that you can't use `@profile` simultaneously with `@profile_walltime`.

As mentioned above, since this tool sample not only running tasks, but also sleeping tasks and tasks performing IO, it can be used to diagnose performance issues such as lock contention, IO bottlenecks, and other issues that are not visible in the CPU profile.
