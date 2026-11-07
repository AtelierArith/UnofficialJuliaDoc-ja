```julia
is_manifest_current(path::AbstractString)
```

`path` にあるプロジェクトのマニフェストが、現在のプロジェクトファイルに基づいて解決されているかどうかを返します。たとえば、プロジェクトの compat エントリを変更したものの、マニフェストを再解決していない場合は、false を返します。

マニフェストにプロジェクトハッシュが記録されていない場合、またはマニフェストファイルが存在しない場合は、`nothing` を返します。

この関数は、マニフェストがプロジェクトファイルと同期していることをテストで確認するために使用できます。

```julia
using Pkg, Test
@test Pkg.is_manifest_current(pwd())  # Check current project
@test Pkg.is_manifest_current("/path/to/project")  # Check specific project
```
