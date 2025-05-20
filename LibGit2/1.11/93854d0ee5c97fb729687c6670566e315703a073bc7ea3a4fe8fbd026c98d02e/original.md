```
abort(rb::GitRebase) -> Csize_t
```

Cancel the in-progress rebase, undoing all changes made so far and returning the parent repository of `rb` and its working directory to their state before the rebase was initiated. Return `0` if the abort is successful, `LibGit2.Error.ENOTFOUND` if no rebase is in progress (for example, if the rebase had completed), and `-1` for other errors.
