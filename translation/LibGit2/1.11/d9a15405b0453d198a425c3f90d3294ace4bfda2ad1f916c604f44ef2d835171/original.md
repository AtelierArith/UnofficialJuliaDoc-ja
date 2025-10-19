```julia
LibGit2.gitdir(repo::GitRepo)
```

Return the location of the "git" files of `repo`:

  * for normal repositories, this is the location of the `.git` folder.
  * for bare repositories, this is the location of the repository itself.

See also [`workdir`](@ref), [`path`](@ref).
