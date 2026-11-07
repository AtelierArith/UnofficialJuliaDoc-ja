```julia
compare_version_cap(a::String, b::String, a_comparator, b_comparator)
```

Example comparison strategy for `set_comparison_strategy!()` that implements a version cap for host platforms that support *up to* a particular version number.  As an example, if an artifact is built for macOS 10.9, it can run on macOS 10.11, however if it were built for macOS 10.12, it could not.  Therefore, the host platform of macOS 10.11 has a version cap at `v"10.11"`.

Note that because both hosts and artifacts are represented with `Platform` objects it is possible to call `platforms_match()` with two artifacts, a host and an artifact, an artifact and a host, and even two hosts.  We attempt to do something intelligent for all cases, but in the case of comparing version caps between two hosts, we return `true` only if the two host platforms are in fact identical.
