```julia
MultiSelectMenu(options::Vector{String}; pagesize::Int=10, selected=[], kwargs...)
```

MultiSelectMenu オブジェクトを作成します。ユーザー入力を取得するには `request(menu::MultiSelectMenu)` を使用します。選択されたオプションのインデックスを含む `Set` が返されます。

# Arguments

  * `options::Vector{String}`: 表示するオプション
  * `pagesize::Int=10`: 一度に表示するオプションの数。length(options) > pagesize の場合、メニューはスクロールします
  * `selected=[]`: あらかじめ選択されている項目。`i ∈ selected` は、`options[i]` があらかじめ選択されていることを意味します。

追加のキーワード引数はすべて [`TerminalMenus.MultiSelectConfig`](@ref) に渡されます。

!!! compat "Julia 1.6"
    `selected` 引数を使用するには、Julia 1.6 以降が必要です。

