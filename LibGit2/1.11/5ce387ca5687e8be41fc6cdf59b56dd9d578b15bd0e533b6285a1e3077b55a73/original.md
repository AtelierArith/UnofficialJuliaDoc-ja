```julia
LibGit2.tag_create(repo::GitRepo, tag::AbstractString, commit; kwargs...)
```

Create a new git tag `tag` (e.g. `"v0.5"`) in the repository `repo`, at the commit `commit`.

The keyword arguments are:

  * `msg::AbstractString=""`: the message for the tag.
  * `force::Bool=false`: if `true`, existing references will be overwritten.
  * `sig::Signature=Signature(repo)`: the tagger's signature.
