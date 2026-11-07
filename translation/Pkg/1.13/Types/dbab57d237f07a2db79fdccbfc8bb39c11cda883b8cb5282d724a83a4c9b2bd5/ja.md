```julia
project_resolve_hash(env::EnvCache, julia_version)
```

マニフェストに記録される `project_hash` の `julia_version` の Pkg。古いバージョンの Julia で解決されたマニフェストには、そのバージョンのハッシュが必要です。そうでない場合、マニフェストはプロジェクトと一致していないと報告されます。これより新しいバージョンの Julia では、この Pkg のハッシュが取得されます。
