```julia
edit(function, [types])
edit(module)
```

関数の定義を編集します。必要に応じて型のタプルを指定すると、編集するメソッドを選択できます。モジュールの場合は、メインのソースファイルを開きます。まず、モジュールを `using` または `import` で読み込んでおく必要があります。

!!! compat "Julia 1.1"
    モジュールに対する `edit` の使用には、Julia 1.1 以降が必要です。


指定した行でファイルを開けるようにするには、事前に `InteractiveUtils.define_editor` を呼び出す必要がある場合があります。
