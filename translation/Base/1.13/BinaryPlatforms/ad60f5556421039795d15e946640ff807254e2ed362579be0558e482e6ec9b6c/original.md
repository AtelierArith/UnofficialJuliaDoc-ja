```julia
parse_dl_name_version(path::String, platform::AbstractPlatform)
```

Given a path to a dynamic library, parse out what information we can from the filename.  E.g. given something like "lib/libfoo.so.3.2", this function returns `"libfoo", v"3.2"`.  If the path name is not a valid dynamic library, this method throws an error.  If no soversion can be extracted from the filename, as in "libbar.so" this method returns `"libbar", nothing`.
