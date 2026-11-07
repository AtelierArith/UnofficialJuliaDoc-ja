```julia
Regex(pattern[, flags]) <: AbstractPattern
```

正規表現を表す型です。`Regex` オブジェクトを使うと、文字列を [`match`](@ref) で照合できます。

`Regex` オブジェクトは、[`@r_str`](@ref) 文字列マクロを使って作成できます。`pattern` 文字列に補間が必要な場合は、通常 `Regex(pattern[, flags])` コンストラクターを使います。フラグの詳細については、文字列マクロのドキュメントを参照してください。

!!! note
    補間される変数をエスケープするには、`\Q` と `\E` を使います（例: `Regex("\\Q$x\\E")`）

