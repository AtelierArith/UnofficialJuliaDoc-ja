```julia
macro
```

`macro`は、生成されたコードをプログラムに挿入するためのメソッドを定義します。マクロは、引数の式のシーケンスを返される式にマッピングし、結果の式はマクロが呼び出されたポイントでプログラムに直接置き換えられます。マクロは、[`eval`](@ref Main.eval)を呼び出すことなく生成されたコードを実行する方法であり、生成されたコードは単に周囲のプログラムの一部になります。マクロの引数には、式、リテラル値、およびシンボルが含まれる場合があります。マクロは可変数の引数（varargs）に対して定義できますが、キーワード引数は受け付けません。すべてのマクロは、呼び出された行番号とファイル名を含む`__source__`引数と、マクロが展開されるモジュールを示す`__module__`引数が暗黙的に渡されます。

マクロの書き方についての詳細は、[Metaprogramming](@ref)のマニュアルセクションを参照してください。

# 例

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
