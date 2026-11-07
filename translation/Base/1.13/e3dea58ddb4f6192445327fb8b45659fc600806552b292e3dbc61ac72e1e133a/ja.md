```julia
Base.isrelocatable(pkg::PkgId)
```

指定された PkgId がアクティブなプロジェクト内でプリコンパイル済みかどうか、および関連するキャッシュが再配置可能かどうかを返します。

!!! compat "Julia 1.11"
    この関数を使用するには、Julia 1.11 以降が必要です。

