```julia
macro
```

`macro`は、プログラムに生成コードを挿入するためのメソッドを定義します。マクロは引数式の列を受け取り、返された式を、マクロが呼び出された位置にプログラムへ直接置き換えます。生成コードは周囲のプログラムの一部となるため、マクロを使えば[`eval`](@ref Main.eval)を呼び出さずに生成コードを実行できます。マクロの引数には、式、リテラル値、シンボルを指定できます。可変個数の引数（varargs）を受け取るマクロも定義できますが、キーワード引数は受け付けません。また、すべてのマクロには暗黙的に`__source__`と`__module__`も渡されます。前者にはマクロの呼び出し元の行番号とファイル名が含まれ、後者はマクロが展開されるモジュールです。

マクロの書き方について詳しくは、マニュアルの[Metaprogramming](@ref)の節を参照してください。

# Examples

```jldoctest
julia> macro sayhello(name)
           return :( println("Hello, ", $name, "!") )
       end
@sayhello (macro with 1 method)

julia> @sayhello "Charlie"
Hello, Charlie!

julia> macro saylots(x...)
           return :( println("Say: ", $(x...)) )
       end
@saylots (macro with 1 method)

julia> @saylots "hey " "there " "friend"
Say: hey there friend
```
