```julia
Base.isprecompiled(pkg::PkgId; ignore_loaded::Bool=false)
```

指定した PkgId がアクティブなプロジェクト内でプリコンパイル済みかどうかを返します。

デフォルトでは、依存関係の異なるバージョンが現在読み込まれている場合の扱いについて、コードの読み込み時と同じ方法で判定します。読み込み済みのモジュールを無視し、新しい Julia セッションであるかのように判定するには、`ignore_loaded=true` を指定します。

!!! compat "Julia 1.10"
    この関数を使用するには、Julia 1.10 以降が必要です。

