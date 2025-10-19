```julia
reenable_sigint(f::Function)
```

関数の実行中にCtrl-Cハンドラを再有効化します。[`disable_sigint`](@ref)の効果を一時的に逆転させます。
