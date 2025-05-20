```
rewrite(
    [ predicate, ] old_tarball, [ new_tarball ];
    [ portable = false, ]
) -> new_tarball

    predicate   :: Header --> Bool
    old_tarball :: Union{AbstractString, AbstractCmd, IO}
    new_tarball :: Union{AbstractString, AbstractCmd, IO}
    portable    :: Bool
```

Rewrite `old_tarball` to the standard format that `create` generates, while also checking that it doesn't contain anything that would cause `extract` to raise an error. This is functionally equivalent to doing

```
Tar.create(Tar.extract(predicate, old_tarball), new_tarball)
```

However, it never extracts anything to disk and instead uses the `seek` function to navigate the old tarball's data. If no `new_tarball` argument is passed, the new tarball is written to a temporary file whose path is returned.

If a `predicate` function is passed, it is called on each `Header` object that is encountered while extracting `old_tarball` and the entry is skipped unless `predicate(hdr)` is true. This can be used to selectively rewrite only parts of an archive, to skip entries that would cause `extract` to throw an error, or to record what content is encountered during the rewrite process.

Before it is passed to the predicate function, the `Header` object is somewhat modified from the raw header in the tarball: the `path` field is normalized to remove `.` entries and replace multiple consecutive slashes with a single slash. If the entry has type `:hardlink`, the link target path is normalized the same way so that it will match the path of the target entry; the size field is set to the size of the target path (which must be an already-seen file).

If the `portable` flag is true then path names are checked for validity on Windows, which ensures that they don't contain illegal characters or have names that are reserved. See https://stackoverflow.com/a/31976060/659248 for details.
