```julia
macro
```

`macro`は、生成したコードをプログラムに挿入するためのメソッドを定義します。マクロは引数式の列を受け取り、式を返します。返された式は、マクロが呼び出された位置にプログラムへ直接挿入されます。生成したコードは周囲のプログラムの一部となるため、マクロを使えば[`eval`](@ref Main.eval)を呼び出さずにコードを実行できます。マクロの引数には、式、リテラル値、シンボルを指定できます。可変個数の引数（varargs）を受け取るマクロも定義できますが、キーワード引数は受け取りません。また、すべてのマクロには暗黙的に`__source__`（マクロの呼び出し元の行番号とファイル名を含む）と、`__module__`（マクロが展開されるモジュール）も渡されます。

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
