```
create(
    [ predicate, ] dir, [ tarball ];
    [ skeleton, ] [ portable = false ]
) -> tarball

    predicate :: String --> Bool
    dir       :: AbstractString
    tarball   :: Union{AbstractString, AbstractCmd, IO}
    skeleton  :: Union{AbstractString, AbstractCmd, IO}
    portable  :: Bool
```

Create a tar archive ("tarball") of the directory `dir`. The resulting archive is written to the path `tarball` or if no path is specified, a temporary path is created and returned by the function call. If `tarball` is an IO object then the tarball content is written to that handle instead (the handle is left open).

If a `predicate` function is passed, it is called on each system path that is encountered while recursively searching `dir` and `path` is only included in the tarball if `predicate(path)` is true. If `predicate(path)` returns false for a directory, then the directory is excluded entirely: nothing under that directory will be included in the archive.

If the `skeleton` keyword is passed then the file or IO handle given is used as a "skeleton" to generate the tarball. You create a skeleton file by passing the `skeleton` keyword to the `extract` command. If `create` is called with that skeleton file and the extracted files haven't changed, an identical tarball is recreated. The `skeleton` and `predicate` arguments cannot be used together.

If the `portable` flag is true then path names are checked for validity on Windows, which ensures that they don't contain illegal characters or have names that are reserved. See https://stackoverflow.com/a/31976060/659248 for details.
