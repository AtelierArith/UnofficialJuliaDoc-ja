```julia
islink(path)::Bool
islink(path_elements...)::Bool
```

`path`がシンボリックリンクを指している場合は`true`を返し、そうでない場合は`false`を返します。
