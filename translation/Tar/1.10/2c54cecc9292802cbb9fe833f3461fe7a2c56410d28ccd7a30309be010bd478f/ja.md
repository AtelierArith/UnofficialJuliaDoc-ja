```julia
list(tarball; [ strict = true ]) -> Vector{Header}
list(callback, tarball; [ strict = true ])

    callback  :: Header, [ <data> ] --> Any
    tarball   :: Union{AbstractString, AbstractCmd, IO}
    strict    :: Bool
```

パス `tarball` にある tar アーカイブ（「tarball」）の内容を一覧表示します。`tarball` が IO ハンドルの場合は、そのストリームから tar の内容を読み取ります。`Header` 構造体のベクターを返します。詳細は [`Header`](@ref) を参照してください。

`callback` が指定されている場合は、ヘッダーのベクターを返す代わりに、各 `Header` に対してコールバックを呼び出します。tarball 内の項目数が多い場合や、エラーが発生する前の項目を調べたい場合に便利です。`callback` 関数が、型 `Vector{UInt8}` または `Vector{Pair{Symbol, String}}` のいずれかの第 2 引数を受け取れる場合、その引数には生のヘッダーデータを表す値が渡されます。これは、単一のバイトベクター、またはフィールド名とそのフィールドの生データを対応付けたペアのベクターのいずれかです（これらのフィールドを連結すると、ヘッダーの生データになります）。

デフォルトでは、`list` は、`extract` 関数が展開を拒否する tarball の内容に遭遇するとエラーになります。`strict=false` を指定すると、これらのチェックを省略し、`extract` が展開するかどうかにかかわらず、tar ファイルの内容をすべて一覧表示します。悪意のある tarball は、危険な操作をさせようと、巧妙で予期しないさまざまな手口を使うことがあるため注意してください。

`tarball` 引数がスケルトンファイル（`extract` および `create` を参照）の場合、`list` はファイルヘッダーからそれを判別し、スケルトンファイルのヘッダーを適切に一覧表示するか、順に処理します。
