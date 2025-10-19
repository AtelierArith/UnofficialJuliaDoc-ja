```julia
return
```

`return x` は、囲まれた関数を早期に終了させ、与えられた値 `x` を呼び出し元に返します。値なしの `return` は `return nothing` と同等です（[`nothing`](@ref)を参照）。

```julia
function compare(a, b)
    a == b && return "equal to"
    a < b ? "less than" : "greater than"
end
```

一般に、関数本体内のどこにでも `return` 文を置くことができます。深くネストされたループや条件文の中でも可能ですが、`do` ブロックには注意が必要です。例えば：

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

最初の例では、return は偶数に出会った時点で `test1` から抜け出すため、`test1([5,6,7])` は `12` を返します。

2番目の例も同じように動作すると思うかもしれませんが、実際にはそこでの `return` は *内側* の関数（`do` ブロック内）からのみ抜け出し、`map` に値を返します。したがって、`test2([5,6,7])` は `[5,12,7]` を返します。

トップレベルの式（すなわち、任意の関数の外）で使用されると、`return` は現在のトップレベルの式全体を早期に終了させます。
