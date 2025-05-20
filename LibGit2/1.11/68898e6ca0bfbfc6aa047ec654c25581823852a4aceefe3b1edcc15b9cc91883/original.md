```
message(c::GitCommit, raw::Bool=false)
```

Return the commit message describing the changes made in commit `c`. If `raw` is `false`, return a slightly "cleaned up" message (which has any leading newlines removed). If `raw` is `true`, the message is not stripped of any such newlines.
