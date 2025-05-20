```
LibGit2.RebaseOperation
```

Describes a single instruction/operation to be performed during the rebase. Matches the [`git_rebase_operation`](https://libgit2.org/libgit2/#HEAD/type/git_rebase_operation_t) struct.

The fields represent:

  * `optype`: the type of rebase operation currently being performed. The options are:

      * `REBASE_OPERATION_PICK`: cherry-pick the commit in question.
      * `REBASE_OPERATION_REWORD`: cherry-pick the commit in question, but rewrite its message using the prompt.
      * `REBASE_OPERATION_EDIT`: cherry-pick the commit in question, but allow the user to edit the commit's contents and its message.
      * `REBASE_OPERATION_SQUASH`: squash the commit in question into the previous commit. The commit messages of the two commits will be merged.
      * `REBASE_OPERATION_FIXUP`: squash the commit in question into the previous commit. Only the commit message of the previous commit will be used.
      * `REBASE_OPERATION_EXEC`: do not cherry-pick a commit. Run a command and continue if the command exits successfully.
  * `id`: the [`GitHash`](@ref) of the commit being worked on during this rebase step.
  * `exec`: in case `REBASE_OPERATION_EXEC` is used, the command to run during this step (for instance, running the test suite after each commit).
