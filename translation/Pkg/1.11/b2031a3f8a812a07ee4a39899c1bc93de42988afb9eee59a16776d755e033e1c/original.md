```
Pkg.dependencies()::Dict{UUID, PackageInfo}
```

This feature is considered experimental.

Query the dependency graph of the active project. The result is a `Dict` that maps a package UUID to a `PackageInfo` struct representing the dependency (a package).

# `PackageInfo` fields

| Field                  | Description                                                                       |
|:---------------------- |:--------------------------------------------------------------------------------- |
| `name`                 | The name of the package                                                           |
| `version`              | The version of the package (this is `Nothing` for stdlibs)                        |
| `tree_hash`            | A file hash of the package directory tree                                         |
| `is_direct_dep`        | The package is a direct dependency                                                |
| `is_pinned`            | Whether a package is pinned                                                       |
| `is_tracking_path`     | Whether a package is tracking a path                                              |
| `is_tracking_repo`     | Whether a package is tracking a repository                                        |
| `is_tracking_registry` | Whether a package is being tracked by registry i.e. not by path nor by repository |
| `git_revision`         | The git revision when tracking by repository                                      |
| `git_source`           | The git source when tracking by repository                                        |
| `source`               | The directory containing the source code for that package                         |
| `dependencies`         | The dependencies of that package as a vector of UUIDs                             |
