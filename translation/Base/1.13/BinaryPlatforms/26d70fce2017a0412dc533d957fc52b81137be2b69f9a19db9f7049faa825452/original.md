```julia
Platform
```

A `Platform` represents all relevant pieces of information that a julia process may need to know about its execution environment, such as the processor architecture, operating system, libc implementation, etc...  It is, at its heart, a key-value mapping of tags (such as `arch`, `os`, `libc`, etc...) to values (such as `"arch" => "x86_64"`, or `"os" => "windows"`, etc...).  `Platform` objects are extensible in that the tag mapping is open for users to add their own mappings to, as long as the mappings do not conflict with the set of reserved tags: `arch`, `os`, `os_version`, `libc`, `call_abi`, `libgfortran_version`, `libstdcxx_version`, `cxxstring_abi` and `julia_version`.

Valid tags and values are composed of alphanumeric and period characters.  All tags and values will be lowercased when stored to reduce variation.

Example:

```julia
Platform("x86_64", "windows"; cuda = "10.1")
```
