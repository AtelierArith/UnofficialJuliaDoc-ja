```julia
let
```

`let` ブロックは新しいハードスコープを作り、必要に応じて新しいローカル束縛を導入します。

[other scope constructs](@ref man-scope-table) と同様に、`let` ブロックは、新たに導入されたローカル変数を参照できるコードの範囲を定めます。さらに、構文には、`let` と同じ行に任意で記述できる、カンマ区切りの代入と変数名に関する特別な意味があります。

```julia
let var1 = value1, var2, var3 = value3
    code
end
```

この行で導入された変数は `let` ブロック内のローカル変数となり、代入は順番に評価されます。その際、各右辺は左辺の名前を考慮しないスコープで評価されます。そのため、`let x = x` のように書くことができます。この場合、2つの `x` 変数は別個のものであり、左辺は外側のスコープにある `x` をローカルでシャドーイングします。ローカルスコープに入るたびに新しいローカル変数が作られるため、これは便利なイディオムにもなり得ます。ただし、その違いが観察できるのは、クロージャを介してスコープの外まで存続する変数の場合に限られます。上の例にある `var2` のように、代入を伴わない `let` 変数は、新しいローカル変数を宣言しますが、まだ値には束縛されていません。

一方、[`begin`](@ref) ブロックも複数の式をまとめますが、スコープを導入せず、特別な代入構文も持ちません。

### Examples

以下の関数では、`map` によって3回繰り返し更新される `x` が1つだけあります。返されるクロージャはすべて、その `x` を最終値で参照します。

```jldoctest
julia> function test_outer_x()
           x = 0
           map(1:3) do _
               x += 1
               return ()->x
           end
       end
test_outer_x (generic function with 1 method)

julia> [f() for f in test_outer_x()]
3-element Vector{Int64}:
 3
 3
 3
```

しかし、新しいローカル変数を導入する `let` ブロックを追加すると、同じ名前を使って（シャドーイングして）いても、各反復で1つずつ、計3つの異なる変数がキャプチャされます。

```jldoctest
julia> function test_let_x()
           x = 0
           map(1:3) do _
               x += 1
               let x = x
                   return ()->x
               end
           end
       end
test_let_x (generic function with 1 method)

julia> [f() for f in test_let_x()]
3-element Vector{Int64}:
 1
 2
 3
```

新しいローカル変数を導入するスコープ構文は、繰り返し実行されるとすべてこのように振る舞います。`let` の特徴は、外側に同名の変数がある場合にそれをシャドーイングできる、新しい `local` を簡潔に宣言できることです。たとえば、`do` 関数の引数を直接使った場合も、同様に3つの異なる変数がキャプチャされます。

```jldoctest
julia> function test_do_x()
           map(1:3) do x
               return ()->x
           end
       end
test_do_x (generic function with 1 method)

julia> [f() for f in test_do_x()]
3-element Vector{Int64}:
 1
 2
 3
```
