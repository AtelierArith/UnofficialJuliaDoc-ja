```
PackageSpec(name::String, [uuid::UUID, version::VersionNumber])
PackageSpec(; name, url, path, subdir, rev, version, mode, level)
```

A `PackageSpec` is a representation of a package with various metadata. This includes:

  * The `name` of the package.
  * The package's unique `uuid`.
  * A `version` (for example when adding a package). When upgrading, can also be an instance of the enum [`UpgradeLevel`](@ref). If the version is given as a `String` this means that unspecified versions are "free", for example `version="0.5"` allows any version `0.5.x` to be installed. If given as a `VersionNumber`, the exact version is used, for example `version=v"0.5.3"`.
  * A `url` and an optional git `rev`ision. `rev` can be a branch name or a git commit SHA1.
  * A local `path`. This is equivalent to using the `url` argument but can be more descriptive.
  * A `subdir` which can be used when adding a package that is not in the root of a repository.

Most functions in Pkg take a `Vector` of `PackageSpec` and do the operation on all the packages in the vector.

Many functions that take a `PackageSpec` or a `Vector{PackageSpec}` can be called with a more concise notation with `NamedTuple`s. For example, `Pkg.add` can be called either as the explicit or concise versions as:

| Explicit                                                            | Concise                                          |
|:------------------------------------------------------------------- |:------------------------------------------------ |
| `Pkg.add(PackageSpec(name="Package"))`                              | `Pkg.add(name = "Package")`                      |
| `Pkg.add(PackageSpec(url="www.myhost.com/MyPkg")))`                 | `Pkg.add(url="www.myhost.com/MyPkg")`            |
| `Pkg.add([PackageSpec(name="Package"), PackageSpec(path="/MyPkg"])` | `Pkg.add([(;name="Package"), (;path="/MyPkg")])` |

Below is a comparison between the REPL mode and the functional API:

| `REPL`               | `API`                                                |
|:-------------------- |:---------------------------------------------------- |
| `Package`            | `PackageSpec("Package")`                             |
| `Package@0.2`        | `PackageSpec(name="Package", version="0.2")`         |
| -                    | `PackageSpec(name="Package", version=v"0.2.1")`      |
| `Package=a67d...`    | `PackageSpec(name="Package", uuid="a67d...")`        |
| `Package#master`     | `PackageSpec(name="Package", rev="master")`          |
| `local/path#feature` | `PackageSpec(path="local/path"; rev="feature")`      |
| `www.mypkg.com`      | `PackageSpec(url="www.mypkg.com")`                   |
| `--major Package`    | `PackageSpec(name="Package", version=UPLEVEL_MAJOR)` |
