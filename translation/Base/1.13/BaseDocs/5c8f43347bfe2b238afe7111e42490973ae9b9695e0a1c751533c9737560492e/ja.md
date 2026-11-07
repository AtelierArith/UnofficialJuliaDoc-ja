```julia
Base.compilerbarrier(setting::Symbol, val)
```

この関数は、指定されたコンパイルフェーズでコンパイラバリアとして機能します。この組み込み関数の動的な意味は、`val`引数を変更せずに返すことです。ただし、`setting`によっては、コンパイラがこの動作を前提とすることを防げます。

現在、次のいずれかの`setting`が許可されています。

  * 抽象解釈に対するバリア:

      * `:type`: この関数呼び出しの戻り値の型は、常に`Any`として推論されます（抽象解釈に対する最も強いバリア）。
      * `:const`: この関数呼び出しの戻り値の型は、`val`に関する定数情報を拡大したうえで推論されます。
      * `:conditional`: この関数呼び出しの戻り値の型は、`val`に関する条件付き情報を拡大したうえで推論されます（以下の例を参照）。
  * 最適化に対するバリアは、まだ実装されていません。

!!! note
    この関数は、コンパイル時に正確に判明している`setting`とともに使用することを想定しています。`setting`がコンパイル時に正確に判明していない場合、コンパイラは最も強いバリアを出力します。コンパイル時の警告は出されません。


# Examples

```julia
julia> Base.return_types((Int,)) do a
           x = compilerbarrier(:type, a) # `x` won't be inferred as `x::Int`
           return x
       end |> only
Any

julia> Base.return_types() do
           x = compilerbarrier(:const, 42)
           if x == 42 # no constant information here, so inference also accounts for the else branch
               return x # but `x` is still inferred as `x::Int` at least here
           else
               return nothing
           end
       end |> only
Union{Nothing, Int64}

julia> Base.return_types((Union{Int,Nothing},)) do a
           if compilerbarrier(:conditional, isa(a, Int))
               # the conditional information `a::Int` isn't available here (leading to less accurate return type inference)
               return a
           else
               return nothing
           end
       end |> only
Union{Nothing, Int64}
```
