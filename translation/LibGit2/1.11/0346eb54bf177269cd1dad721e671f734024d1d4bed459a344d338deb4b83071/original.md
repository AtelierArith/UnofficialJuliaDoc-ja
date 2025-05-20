```
isattached(repo::GitRepo) -> Bool
```

Determine if `repo` is detached - that is, whether its HEAD points to a commit (detached) or whether HEAD points to a branch tip (attached).
