```julia
stage(ie::IndexEntry) -> Cint
```

Get the stage number of `ie`. The stage number `0` represents the current state of the working tree, but other numbers can be used in the case of a merge conflict. In such a case, the various stage numbers on an `IndexEntry` describe which side(s) of the conflict the current state of the file belongs to. Stage `0` is the state before the attempted merge, stage `1` is the changes which have been made locally, stages `2` and larger are for changes from other branches (for instance, in the case of a multi-branch "octopus" merge, stages `2`, `3`, and `4` might be used).
