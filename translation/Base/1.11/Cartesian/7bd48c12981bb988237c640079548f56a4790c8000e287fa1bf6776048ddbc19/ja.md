```
@nloops N itersym rangeexpr bodyexpr
@nloops N itersym rangeexpr preexpr bodyexpr
@nloops N itersym rangeexpr preexpr postexpr bodyexpr
```

`N` 個のネストされたループを生成します。`itersym` をイテレーション変数のプレフィックスとして使用します。`rangeexpr` は無名関数式であるか、単純なシンボル `var` の場合、範囲は次のようになります：`axes(var, d)` （次元 `d` のため）。

オプションで、「pre」と「post」の式を提供できます。これらはそれぞれ、各ループの本体の最初と最後に実行されます。例えば：

```
@nloops 2 i A d -> j_d = min(i_d, 5) begin
    s += @nref 2 A j
end
```

は次のように生成されます：

```
for i_2 = axes(A, 2)
    j_2 = min(i_2, 5)
    for i_1 = axes(A, 1)
        j_1 = min(i_1, 5)
        s += A[j_1, j_2]
    end
end
```

もしポスト式だけが必要な場合は、プレ式に [`nothing`](@ref) を指定してください。括弧とセミコロンを使用することで、複数のステートメント式を提供できます。
