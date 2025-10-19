```julia
Base.isprecompiled(pkg::PkgId; ignore_loaded::Bool=false)
```

指定されたプロジェクト内の PkgId がプリコンパイルされているかどうかを返します。

デフォルトでは、このチェックは、異なるバージョンの依存関係が現在読み込まれているときに、コードの読み込みが期待されるものと同じアプローチを観察します。読み込まれたモジュールを無視し、新しい Julia セッションのように答えるには、`ignore_loaded=true` を指定します。

!!! compat "Julia 1.10"
    この関数は少なくとも Julia 1.10 が必要です。

