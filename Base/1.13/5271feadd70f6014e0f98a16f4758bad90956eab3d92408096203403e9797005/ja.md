```julia
recursive_prefs_merge(base::Dict{String, Any}, overrides::Vector{Dict{String, Any}})
```

ネストされた辞書の上書きを適切に反映しながら、設定辞書を再帰的にマージするヘルパー関数。
