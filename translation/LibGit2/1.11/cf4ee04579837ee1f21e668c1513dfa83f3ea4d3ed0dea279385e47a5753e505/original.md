```julia
LibGit2.path(repo::GitRepo)
```

Return the base file path of the repository `repo`.

  * for normal repositories, this will typically be the parent directory of the ".git" directory (note: this may be different than the working directory, see `workdir` for more details).
  * for bare repositories, this is the location of the "git" files.

See also [`gitdir`](@ref), [`workdir`](@ref).
