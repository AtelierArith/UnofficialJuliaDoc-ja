```julia
Base.isprecompiled(pkg::PkgId; ignore_loaded::Bool=false)
```

指定した PkgId がアクティブなプロジェクト内でプリコンパイル済みかどうかを返します。

デフォルトでは、依存関係の異なるバージョンが現在ロードされている場合の扱いについて、コードのロード時と同じ方法で判定します。ロード済みのモジュールを無視し、新しい Julia セッションでの結果を得るには、`ignore_loaded=true` を指定してください。

!!! compat "Julia 1.10"
    この関数を使用するには、Julia 1.10 以降が必要です。

