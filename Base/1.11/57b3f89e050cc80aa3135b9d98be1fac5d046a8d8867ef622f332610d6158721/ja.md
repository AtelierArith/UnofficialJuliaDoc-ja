```
replace_ref_begin_end!(ex)
```

再帰的に、"ref"式（すなわち`A[...]`）`ex`内の`:begin`および`:end`のシンボルの出現を適切な関数呼び出し（`firstindex`または`lastindex`）に置き換えます。置き換えは最も近い囲むrefを使用するため、

```
A[B[end]]
```

は次のように変換されるべきです。

```
A[B[lastindex(B)]]
```
