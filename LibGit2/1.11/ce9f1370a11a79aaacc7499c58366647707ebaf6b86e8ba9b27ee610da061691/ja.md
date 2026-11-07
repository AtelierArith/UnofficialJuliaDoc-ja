```julia
isattached(repo::GitRepo)::Bool
```

`repo` が detached かどうか、つまり HEAD がコミットを指している（detached）のか、ブランチの先端を指している（attached）のかを判定します。
