```
@s_str -> SubstitutionString
```

置換文字列を構築します。これは正規表現の置換に使用されます。文字列内では、形式 `\N` のシーケンスは正規表現の N 番目のキャプチャグループを参照し、`\g<groupname>` は名前付きキャプチャグループ `groupname` を参照します。

# 例

```jldoctest
julia> msg = "#Hello# from Julia";

julia> replace(msg, r"#(.+)# from (?<from>\w+)" => s"FROM: \g<from>; MESSAGE: \1")
"FROM: Julia; MESSAGE: Hello"
```
