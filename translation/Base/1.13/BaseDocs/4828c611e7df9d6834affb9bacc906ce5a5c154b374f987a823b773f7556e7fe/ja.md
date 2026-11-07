```julia
Core.finalizer(f, o)
```

これは [`Base.finalizer`](@ref) の実装詳細であり、エンドユーザーは代わりに後者を使用してください。

# Differences from `Base.finalizer`

`Core.finalizer` のインターフェースは、基本的に `Base.finalizer` と同じですが、いくつか細かな違いがあります。これらの違いは、完全性のためにここに記載しています（`Base.finalizer` とは異なり、安定性は保証されません）。

現在の違いは次のとおりです。

  * `Core.finalizer` は、`o` が変更可能かどうかを確認しません。不変オブジェクトに対してファイナライザーを登録しようとすることは、未定義の動作です。
  * 値 `f` は Julia オブジェクトでなければなりません。`Core.finalizer` は、生の C 関数ポインターをサポートしません。
  * `Core.finalizer` は、`o` ではなく `nothing` を返します。
