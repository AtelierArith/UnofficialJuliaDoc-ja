```
;
```

`;` は多くのC系言語と同様にJuliaでも同じ役割を持ち、前の文の終わりを区切るために使用されます。

`;` は行の終わりに必要ではありませんが、単一の行で文を区切ったり、文を単一の式に結合したりするために使用できます。

REPLで行の終わりに `;` を追加すると、その式の結果の印刷を抑制します。

関数の宣言や、オプションで呼び出しの中で、`;` は通常の引数とキーワードを区切ります。

配列リテラルでは、セミコロンで区切られた引数の内容が結合されます。単一の `;` で作られた区切りは垂直に結合します（すなわち、最初の次元に沿って）、`;;` は水平方向に結合します（第二次元）、`;;;` は第三次元に沿って結合します、など。このような区切りは、1の長さのトレーリング次元を追加するために、角括弧の最後の位置でも使用できます。

括弧内の最初の位置にある `;` は、名前付きタプルを構築するために使用できます。同じ `(; ...)` 構文を代入の左側で使用すると、プロパティの分解が可能です。

標準のREPLでは、空の行で `;` を入力するとシェルモードに切り替わります。

# 例

```jldoctest
julia> function foo()
           x = "Hello, "; x *= "World!"
           return x
       end
foo (generic function with 1 method)

julia> bar() = (x = "Hello, Mars!"; return x)
bar (generic function with 1 method)

julia> foo();

julia> bar()
"Hello, Mars!"

julia> function plot(x, y; style="solid", width=1, color="black")
           ###
       end

julia> A = [1 2; 3 4]
2×2 Matrix{Int64}:
 1  2
 3  4

julia> [1; 3;; 2; 4;;; 10*A]
2×2×2 Array{Int64, 3}:
[:, :, 1] =
 1  2
 3  4

[:, :, 2] =
 10  20
 30  40

julia> [2; 3;;;]
2×1×1 Array{Int64, 3}:
[:, :, 1] =
 2
 3

julia> nt = (; x=1) # ; またはトレーリングカンマがなければ、これは x に代入されます
(x = 1,)

julia> key = :a; c = 3;

julia> nt2 = (; key => 1, b=2, c, nt.x)
(a = 1, b = 2, c = 3, x = 1)

julia> (; b, x) = nt2; # プロパティの分解を使用して変数 b と x を設定

julia> b, x
(2, 1)

julia> ; # ; を入力すると、プロンプトが（その場で）次のように変更されます: shell>
shell> echo hello
hello
```
