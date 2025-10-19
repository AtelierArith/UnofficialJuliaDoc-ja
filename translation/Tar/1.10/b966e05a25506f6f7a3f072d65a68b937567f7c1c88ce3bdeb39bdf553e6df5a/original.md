```julia
extract(
    [ predicate, ] tarball, [ dir ];
    [ skeleton = <none>, ]
    [ copy_symlinks = <auto>, ]
    [ set_permissions = true, ]
) -> dir

    predicate       :: Header --> Bool
    tarball         :: Union{AbstractString, AbstractCmd, IO}
    dir             :: AbstractString
    skeleton        :: Union{AbstractString, AbstractCmd, IO}
    copy_symlinks   :: Bool
    set_permissions :: Bool
```

Extract a tar archive ("tarball") located at the path `tarball` into the directory `dir`. If `tarball` is an IO object instead of a path, then the archive contents will be read from that IO stream. The archive is extracted to `dir` which must either be an existing empty directory or a non-existent path which can be created as a new directory. If `dir` is not specified, the archive is extracted into a temporary directory which is returned by `extract`.

If a `predicate` function is passed, it is called on each `Header` object that is encountered while extracting `tarball` and the entry is only extracted if the `predicate(hdr)` is true. This can be used to selectively extract only parts of an archive, to skip entries that cause `extract` to throw an error, or to record what is extracted during the extraction process.

Before it is passed to the predicate function, the `Header` object is somewhat modified from the raw header in the tarball: the `path` field is normalized to remove `.` entries and replace multiple consecutive slashes with a single slash. If the entry has type `:hardlink`, the link target path is normalized the same way so that it will match the path of the target entry; the size field is set to the size of the target path (which must be an already-seen file).

If the `skeleton` keyword is passed then a "skeleton" of the extracted tarball is written to the file or IO handle given. This skeleton file can be used to recreate an identical tarball by passing the `skeleton` keyword to the `create` function. The `skeleton` and `predicate` arguments cannot be used together.

If `copy_symlinks` is `true` then instead of extracting symbolic links as such, they will be extracted as copies of what they link to if they are internal to the tarball and if it is possible to do so. Non-internal symlinks, such as a link to `/etc/passwd` will not be copied. Symlinks which are in any way cyclic will also not be copied and will instead be skipped. By default, `extract` will detect whether symlinks can be created in `dir` or not and will automatically copy symlinks if they cannot be created.

If `set_permissions` is `false`, no permissions are set on the extracted files.
