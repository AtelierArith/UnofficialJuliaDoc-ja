```
macro artifact_str(name)
```

Return the on-disk path to an artifact. Automatically looks the artifact up by name in the project's `(Julia)Artifacts.toml` file. Throws an error on if the requested artifact is not present. If run in the REPL, searches for the toml file starting in the current directory, see `find_artifacts_toml()` for more.

If the artifact is marked "lazy" and the package has `using LazyArtifacts` defined, the artifact will be downloaded on-demand with `Pkg` the first time this macro tries to compute the path. The files will then be left installed locally for later.

If `name` contains a forward or backward slash, all elements after the first slash will be taken to be path names indexing into the artifact, allowing for an easy one-liner to access a single file/directory within an artifact.  Example:

```
ffmpeg_path = @artifact"FFMPEG/bin/ffmpeg"
```

!!! compat "Julia 1.3"
    This macro requires at least Julia 1.3.


!!! compat "Julia 1.6"
    Slash-indexing requires at least Julia 1.6.

