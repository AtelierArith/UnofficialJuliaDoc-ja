```julia
FileMonitor(path::AbstractString)
```

Watch file or directory `path` (which must exist) for changes until a change occurs. This function does not poll the file system and instead uses platform-specific functionality to receive notifications from the operating system (e.g. via inotify on Linux). See the NodeJS documentation linked below for details.

`fm = FileMonitor(path)` acts like an auto-reset Event, so `wait(fm)` blocks until there has been at least one event in the file originally at the given path and then returns an object with boolean fields `renamed`, `changed`, `timedout` summarizing all changes that have occurred since the last call to `wait` returned.

This behavior of this function varies slightly across platforms. See [https://nodejs.org/api/fs.html#fs_caveats](https://nodejs.org/api/fs.html#fs_caveats) for more detailed information.
