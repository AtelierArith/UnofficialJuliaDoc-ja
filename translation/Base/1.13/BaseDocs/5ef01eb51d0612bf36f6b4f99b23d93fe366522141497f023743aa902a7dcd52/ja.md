```julia
return
```

`return x` は、指定された値 `x` を呼び出し元に返し、現在の関数を早期に終了します。値を指定せずに `return` だけを使うと、`return nothing` と同じ意味になります（[`nothing`](@ref) を参照）。

```julia
function compare(a, b)
    a == b && return "equal to"
    a < b ? "less than" : "greater than"
end
```

一般に、関数本体のどこにでも `return` 文を置けます。深くネストしたループや条件分岐の中でも使えますが、`do` ブロックでは注意が必要です。たとえば、次のようになります。

```julia
function test1(xs)
    for x in xs
        iseven(x) && return 2x
    end
end

function test2(xs)
    map(xs) do x
        iseven(x) && return 2x
        x
    end
end
```

最初の例では、偶数に達すると return によって `test1` から抜けるため、`test1([5,6,7])` は `12` を返します。

2つ目の例も同じように動作すると思うかもしれませんが、実際には、そこでの `return` は（`do` ブロック内の）内側の関数だけを終了し、値を `map` に返します。その後、`test2([5,6,7])` は `[5,12,7]` を返します。

トップレベルの式（つまり、関数の外側）で使うと、`return` は現在のトップレベル式全体を早期に終了します。
