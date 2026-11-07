```julia
restore(s::State, repo::GitRepo)
```

リポジトリの`repo`を、以前の`State` `s`に戻します。たとえば、マージを試みる前のブランチのHEADなどです。`s`は、[`snapshot`](@ref)関数を使って生成できます。
