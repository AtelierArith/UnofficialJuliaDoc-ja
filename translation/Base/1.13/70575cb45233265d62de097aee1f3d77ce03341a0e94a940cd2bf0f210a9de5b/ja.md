```julia
reenable_sigint(f::Function)
```

関数の実行中に Ctrl-C ハンドラーを再び有効にします。[`disable_sigint`](@ref) の効果を一時的に打ち消します。
