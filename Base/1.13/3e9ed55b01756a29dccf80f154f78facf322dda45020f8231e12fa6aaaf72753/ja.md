```julia
Base.TRACE_EVAL
```

トップレベル評価中の式トレースを全体的に制御します。この設定は、`--trace-eval` コマンドラインオプションより優先されます。

設定値:

  * `nothing` - コマンドラインの `--trace-eval` 設定を使用します（デフォルト）
  * `:no` - 式トレースを無効にします
  * `:loc` - 評価中は位置情報のみを表示します
  * `:full` - 評価中の式全体を表示します

# Examples

```julia
# Enable full expression tracing
Base.TRACE_EVAL = :full

# Show only locations
Base.TRACE_EVAL = :loc

# Disable tracing (overrides command-line setting)
Base.TRACE_EVAL = :no

# Reset to use command-line setting
Base.TRACE_EVAL = nothing
```

関連項目: [Command-line Interface](@ref cli)（`--trace-eval` オプション）。
