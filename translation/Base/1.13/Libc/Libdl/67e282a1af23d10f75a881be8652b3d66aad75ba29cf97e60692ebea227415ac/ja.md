```julia
add_dependency!(library::LazyLibrary, dependency::LazyLibrary)
```

`library`より前に読み込む必要がある依存関係を、動的に追加します。依存関係を構築時に特定できない場合にのみ使用してください。

!!! warning
    この関数で追加した依存関係は**一時的**なもので、現在のプロセス内でのみ有効です。プリコンパイルの境界を越えて保持されることはありません。


可能な場合は、`LazyLibrary`コンストラクターで依存関係を指定してください。

!!! compat "Julia 1.11"
    `add_dependency!`はJulia 1.11で追加されました。


[`LazyLibrary`](@ref)も参照してください。
