```julia
watch_file(path::AbstractString, timeout_s::Real=-1)
```

Watch file or directory `path` for changes until a change occurs or `timeout_s` seconds have elapsed. This function does not poll the file system and instead uses platform-specific functionality to receive notifications from the operating system (e.g. via inotify on Linux). See the NodeJS documentation linked below for details.

The returned value is an object with boolean fields `renamed`, `changed`, and `timedout`, giving the result of watching the file.

This behavior of this function varies slightly across platforms. See ['h': ASCII/Unicode U+0068 (category Ll: Letter, lowercase)'t': ASCII/Unicode U+0074 (category Ll: Letter, lowercase)'t': ASCII/Unicode U+0074 (category Ll: Letter, lowercase)'p': ASCII/Unicode U+0070 (category Ll: Letter, lowercase)'s': ASCII/Unicode U+0073 (category Ll: Letter, lowercase)':': ASCII/Unicode U+003A (category Po: Punctuation, other)'/': ASCII/Unicode U+002F (category Po: Punctuation, other)'/': ASCII/Unicode U+002F (category Po: Punctuation, other)'n': ASCII/Unicode U+006E (category Ll: Letter, lowercase)'o': ASCII/Unicode U+006F (category Ll: Letter, lowercase)'d': ASCII/Unicode U+0064 (category Ll: Letter, lowercase)'e': ASCII/Unicode U+0065 (category Ll: Letter, lowercase)'j': ASCII/Unicode U+006A (category Ll: Letter, lowercase)'s': ASCII/Unicode U+0073 (category Ll: Letter, lowercase)'.': ASCII/Unicode U+002E (category Po: Punctuation, other)'o': ASCII/Unicode U+006F (category Ll: Letter, lowercase)'r': ASCII/Unicode U+0072 (category Ll: Letter, lowercase)'g': ASCII/Unicode U+0067 (category Ll: Letter, lowercase)'/': ASCII/Unicode U+002F (category Po: Punctuation, other)'a': ASCII/Unicode U+0061 (category Ll: Letter, lowercase)'p': ASCII/Unicode U+0070 (category Ll: Letter, lowercase)'i': ASCII/Unicode U+0069 (category Ll: Letter, lowercase)'/': ASCII/Unicode U+002F (category Po: Punctuation, other)'f': ASCII/Unicode U+0066 (category Ll: Letter, lowercase)'s': ASCII/Unicode U+0073 (category Ll: Letter, lowercase)'.': ASCII/Unicode U+002E (category Po: Punctuation, other)'h': ASCII/Unicode U+0068 (category Ll: Letter, lowercase)'t': ASCII/Unicode U+0074 (category Ll: Letter, lowercase)'m': ASCII/Unicode U+006D (category Ll: Letter, lowercase)'l': ASCII/Unicode U+006C (category Ll: Letter, lowercase)'#': ASCII/Unicode U+0023 (category Po: Punctuation, other)'f': ASCII/Unicode U+0066 (category Ll: Letter, lowercase)'s': ASCII/Unicode U+0073 (category Ll: Letter, lowercase)'_': ASCII/Unicode U+005F (category Pc: Punctuation, connector)'c': ASCII/Unicode U+0063 (category Ll: Letter, lowercase)'a': ASCII/Unicode U+0061 (category Ll: Letter, lowercase)'v': ASCII/Unicode U+0076 (category Ll: Letter, lowercase)'e': ASCII/Unicode U+0065 (category Ll: Letter, lowercase)'a': ASCII/Unicode U+0061 (category Ll: Letter, lowercase)'t': ASCII/Unicode U+0074 (category Ll: Letter, lowercase)'s': ASCII/Unicode U+0073 (category Ll: Letter, lowercase)](https://nodejs.org/api/fs.html#fs_caveats) for more detailed information.

This is a thin wrapper over calling `wait` on a [`FileMonitor`](@ref). This function has a small race window between consecutive calls to `watch_file` where the file might change without being detected. To avoid this race, use

```julia
fm = FileMonitor(path)
wait(fm)
```

directly, re-using the same `fm` each time you `wait`.
