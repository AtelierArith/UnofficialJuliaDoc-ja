```
is_manifest_current(path::AbstractString)
```

プロジェクトの `path` に対するマニフェストが現在のプロジェクトファイルから解決されたかどうかを返します。たとえば、プロジェクトの互換性エントリが変更されたが、マニフェストが再解決されていない場合、これは false を返します。

マニフェストにプロジェクトハッシュが記録されていない場合、またはマニフェストファイルが存在しない場合は、`nothing` が返されます。

この関数は、マニフェストがプロジェクトファイルと同期していることを確認するためにテストで使用できます：

```
using Pkg, Test, Package
@test Pkg.is_manifest_current(pkgdir(Package))
```
