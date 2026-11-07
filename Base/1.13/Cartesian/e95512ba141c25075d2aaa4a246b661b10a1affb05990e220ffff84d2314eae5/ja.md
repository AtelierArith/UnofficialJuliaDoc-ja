```julia
@nloops N itersym rangeexpr bodyexpr
@nloops N itersym rangeexpr preexpr bodyexpr
@nloops N itersym rangeexpr preexpr postexpr bodyexpr
```

`N` の入れ子ループを生成します。反復変数の接頭辞には `itersym` を使用します。`rangeexpr` には無名関数式を指定できます。または、単純なシンボル `var` を指定することもでき、その場合、次元 `d` の範囲は `axes(var, d)` になります。

必要に応じて、「pre」と「post」の式を指定できます。これらはそれぞれ、各ループ本体の最初と最後に実行されます。たとえば、次のように指定すると、

```julia
@nloops 2 i A d -> j_d = min(i_d, 5) begin
    s += @nref 2 A j
end
```

次のコードが生成されます。

```julia
for i_2 = axes(A, 2)
    j_2 = min(i_2, 5)
    for i_1 = axes(A, 1)
        j_1 = min(i_1, 5)
        s += A[j_1, j_2]
    end
end
```

post 式だけを指定する場合は、pre 式に [`nothing`](@ref) を指定してください。括弧とセミコロンを使うと、複数の文からなる式を指定できます。
