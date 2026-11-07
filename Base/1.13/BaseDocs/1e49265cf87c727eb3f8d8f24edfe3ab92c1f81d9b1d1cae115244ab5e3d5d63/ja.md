```julia
finally
```

指定した`try`コードブロックがどのように終了しても、その終了時にコードを実行できます。たとえば、開いたファイルが必ず閉じられるようにするには、次のようにします。

```julia
f = open("file")
try
    operate_on_file(f)
finally
    close(f)
end
```

[`try`](@ref)ブロックから制御が抜けると（たとえば、[`return`](@ref)による場合や、通常どおり処理が完了した場合）、[`close(f)`](@ref)が実行されます。`try`ブロックが例外によって終了した場合、その例外は引き続き伝播します。`catch`ブロックは、`try`や`finally`と組み合わせることもできます。この場合、エラーが`catch`によって処理された後に、`finally`ブロックが実行されます。

`try/catch/else/finally`式を評価するとき、式全体の値は、`finally`ブロックを除き、最後に実行されたブロックの値になります。たとえば、次のようになります。

```jldoctest
julia> try
           1
       finally
           2
       end
1

julia> try
           error("")
       catch
           1
       else
           2
       finally
           3
       end
1

julia> try
           0
       catch
           1
       else
           2
       finally
           3
       end
2
```
