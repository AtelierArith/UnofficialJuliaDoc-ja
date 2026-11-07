```julia
@s_str -> SubstitutionString
```

正規表現による置換に使う置換文字列を作成します。文字列内の `\N` という形式の並びは、正規表現の N 番目のキャプチャグループを参照します。また、`\g<groupname>` は、名前が `groupname` の名前付きキャプチャグループを参照します。

# Examples

```jldoctest
julia> msg = "#Hello# from Julia";

julia> replace(msg, r"#(.+)# from (?<from>\w+)" => s"FROM: \g<from>; MESSAGE: \1")
"FROM: Julia; MESSAGE: Hello"
```
