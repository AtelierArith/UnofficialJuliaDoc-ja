```julia
LibGit2.SignatureStruct
```

An action signature (e.g. for committers, taggers, etc). Matches the [`git_signature`](https://libgit2.org/libgit2/#HEAD/type/git_signature) struct.

The fields represent:

  * `name`: The full name of the committer or author of the commit.
  * `email`: The email at which the committer/author can be contacted.
  * `when`: a [`TimeStruct`](@ref) indicating when the commit was  authored/committed into the repository.
