```julia
RadioMenu(options::Vector{String}; pagesize::Int=10,
                                   keybindings::Vector{Char}=Char[],
                                   kwargs...)
```

RadioMenu オブジェクトを作成します。ユーザー入力を受け取るには `request(menu::RadioMenu)` を使用します。`request()` は、ユーザーが選択したオプションのインデックスである `Int` を返します。

# Arguments

  * `options::Vector{String}`: 表示するオプション
  * `pagesize::Int=10`: 一度に表示するオプションの数。length(options) > pagesize の場合、メニューはスクロールします
  * `keybindings::Vector{Char}=Char[]`: `options` から対応する項目を選択するためのショートカット

追加のキーワード引数はすべて [`TerminalMenus.Config`](@ref) に渡されます。

!!! compat "Julia 1.8"
    `keybindings` 引数を使用するには、Julia 1.8 以降が必要です。

