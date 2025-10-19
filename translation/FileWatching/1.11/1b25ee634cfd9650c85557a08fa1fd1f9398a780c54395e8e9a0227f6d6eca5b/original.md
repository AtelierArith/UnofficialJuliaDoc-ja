```julia
FolderMonitor(folder::AbstractString)
```

Watch a file or directory `path` for changes until a change has occurred. This function does not poll the file system and instead uses platform-specific functionality to receive notifications from the operating system (e.g. via inotify on Linux). See the NodeJS documentation linked below for details.

This acts similar to a Channel, so calling `take!` (or `wait`) blocks until some change has occurred. The `wait` function will return a pair where the first field is the name of the changed file (if available) and the second field is an object with boolean fields `renamed` and `changed`, giving the event that occurred on it.

This behavior of this function varies slightly across platforms. See [https://nodejs.org/api/fs.html#fs_caveats](https://nodejs.org/api/fs.html#fs_caveats) for more detailed information.
