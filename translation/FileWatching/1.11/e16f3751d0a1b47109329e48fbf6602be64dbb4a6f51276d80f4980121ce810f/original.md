```julia
watch_file(path::AbstractString, timeout_s::Real=-1)
```

Watch file or directory `path` for changes until a change occurs or `timeout_s` seconds have elapsed. This function does not poll the file system and instead uses platform-specific functionality to receive notifications from the operating system (e.g. via inotify on Linux). See the NodeJS documentation linked below for details.

The returned value is an object with boolean fields `renamed`, `changed`, and `timedout`, giving the result of watching the file.

This behavior of this function varies slightly across platforms. See [https://nodejs.org/api/fs.html#fs_caveats](https://nodejs.org/api/fs.html#fs_caveats) for more detailed information.

This is a thin wrapper over calling `wait` on a [`FileMonitor`](@ref). This function has a small race window between consecutive calls to `watch_file` where the file might change without being detected. To avoid this race, use

```julia
fm = FileMonitor(path)
wait(fm)
```

directly, re-using the same `fm` each time you `wait`.
