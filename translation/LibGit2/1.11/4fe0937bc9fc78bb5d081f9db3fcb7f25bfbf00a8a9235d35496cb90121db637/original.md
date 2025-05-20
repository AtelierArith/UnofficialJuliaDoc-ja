```
commit(repo::GitRepo, msg::AbstractString; kwargs...) -> GitHash
```

Wrapper around [`git_commit_create`](https://libgit2.org/libgit2/#HEAD/group/commit/git_commit_create). Create a commit in the repository `repo`. `msg` is the commit message. Return the OID of the new commit.

The keyword arguments are:

  * `refname::AbstractString=Consts.HEAD_FILE`: if not NULL, the name of the reference to update to point to the new commit. For example, `"HEAD"` will update the HEAD of the current branch. If the reference does not yet exist, it will be created.
  * `author::Signature = Signature(repo)` is a `Signature` containing information about the person who authored the commit.
  * `committer::Signature = Signature(repo)` is a `Signature` containing information about the person who committed the commit to the repository. Not necessarily the same as `author`, for instance if `author` emailed a patch to `committer` who committed it.
  * `tree_id::GitHash = GitHash()` is a git tree to use to create the commit, showing its ancestry and relationship with any other history. `tree` must belong to `repo`.
  * `parent_ids::Vector{GitHash}=GitHash[]` is a list of commits by [`GitHash`](@ref) to use as parent commits for the new one, and may be empty. A commit might have multiple parents if it is a merge commit, for example.
