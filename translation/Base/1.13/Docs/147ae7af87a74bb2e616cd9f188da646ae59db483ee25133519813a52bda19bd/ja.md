```julia
undocumented_names(mod::Module; private=false)
```

`module` 内のドキュメント化されていないシンボル（docstring がないシンボル）を、ソート済みのベクトルとして返します。`private=false`（デフォルト）は、`public` および／または `export` で宣言された識別子のみを返します。一方、`private=true` は、モジュール内のすべてのシンボルを返します（`#` で始まる、コンパイラが生成した非表示シンボルは除きます）。

関連項目：[`names`](@ref)、[`Docs.hasdoc`](@ref)、[`Base.ispublic`](@ref)。
