```julia
list(tarball; [ strict = true ]) -> Vector{Header}
list(callback, tarball; [ strict = true ])

    callback  :: Header, [ <data> ] --> Any
    tarball   :: Union{AbstractString, AbstractCmd, IO}
    strict    :: Bool
```

指定されたパス `tarball` にある tar アーカイブ（「tarball」）の内容をリストします。`tarball` が IO ハンドルの場合、そのストリームから tar の内容を読み取ります。`Header` 構造体のベクターを返します。詳細については [`Header`](@ref) を参照してください。

`callback` が提供されている場合、ヘッダーのベクターを返す代わりに、各 `Header` に対してコールバックが呼び出されます。これは、tarball 内のアイテムの数が多い場合や、tarball 内のエラーの前にアイテムを調べたい場合に便利です。`callback` 関数が `Vector{UInt8}` または `Vector{Pair{Symbol, String}}` のいずれかの型の第二引数を受け入れることができる場合、ヘッダーの生データの表現として、単一のバイトベクターまたはフィールド名をそのフィールドの生データにマッピングするペアのベクターとして呼び出されます（これらのフィールドが連結されると、結果はヘッダーの生データになります）。

デフォルトでは、`list` は `extract` 関数が抽出を拒否するような tarball の内容に遭遇した場合にエラーを返します。`strict=false` の場合、これらのチェックをスキップし、`extract` が抽出するかどうかにかかわらず、tar ファイルのすべての内容をリストします。悪意のある tarball は、あなたを騙して何か悪いことをさせようとするために、さまざまな巧妙で予期しないことを行う可能性があることに注意してください。

`tarball` 引数がスケルトンファイル（`extract` および `create` を参照）である場合、`list` はファイルヘッダーからそれを検出し、適切にスケルトンファイルのヘッダーをリストまたは反復します。
