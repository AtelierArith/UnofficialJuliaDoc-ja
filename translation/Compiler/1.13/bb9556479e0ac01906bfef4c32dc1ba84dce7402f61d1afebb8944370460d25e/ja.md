```julia
info::GlobalAccessInfo <: CallInfo
```

ソースコード内で明示的に`GlobalRef`として記述するのではなく、実行時リフレクションを通じてグローバルにアクセスすることを表します。このようなアクセスを行う組み込み関数（getglobal/setglobalなど）で使用されます。
