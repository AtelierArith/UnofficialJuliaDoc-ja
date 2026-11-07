```julia
Pkg.autoprecompilation_enabled(state::Bool)
```

Pkg の操作における自動プリコンパイルを有効または無効にします。

`state` が `true`（デフォルト）の場合、プロジェクト環境を変更する Pkg の操作によって、影響を受けるパッケージのプリコンパイルが自動的に開始されます。`state` が `false` の場合、自動プリコンパイルは無効になり、[`Pkg.precompile`](@ref) を使って明示的に要求した場合にのみパッケージがプリコンパイルされます。

この設定はグローバルな状態に影響し、同じ Julia セッション内の Pkg 操作を通じて維持されます。[`Pkg.precompile`](@ref) の do 構文と組み合わせることで、プリコンパイルを実行するタイミングをより細かく制御できます。

!!! compat "Julia 1.13"
    この関数を使用するには、Julia 1.13 以降が必要です。


# Examples

```julia
# Disable automatic precompilation
Pkg.autoprecompilation_enabled(false)
Pkg.add("Example")  # Will not trigger auto-precompilation
Pkg.precompile()    # Manual precompilation

# Re-enable automatic precompilation
Pkg.autoprecompilation_enabled(true)
Pkg.add("AnotherPackage")  # Will trigger auto-precompilation
```

[`Pkg.precompile`](@ref) も参照してください。
