# I/O and Network

## General I/O

```@docs
IO
Base.stdout
Base.stderr
Base.stdin
Base.read(::AbstractString)
Base.write(::AbstractString, ::Any)
Base.open
Base.IOStream
Base.IOBuffer
Base.take!(::Base.GenericIOBuffer)
Base.Pipe
Base.link_pipe!
Base.fdio
Base.flush
Base.close
Base.closewrite
Base.write
Base.read
Base.read!
Base.readbytes!
Base.unsafe_read
Base.unsafe_write
Base.readeach
Base.peek
Base.position
Base.seek
Base.seekstart
Base.seekend
Base.skip
Base.mark
Base.unmark
Base.reset(::IO)
Base.ismarked
Base.eof
Base.isreadonly
Base.iswritable
Base.isreadable
Base.isexecutable
Base.isopen
Base.fd
Base.redirect_stdio
Base.redirect_stdout
Base.redirect_stdout(::Function, ::Any)
Base.redirect_stderr
Base.redirect_stderr(::Function, ::Any)
Base.redirect_stdin
Base.redirect_stdin(::Function, ::Any)
Base.readchomp
Base.truncate
Base.skipchars
Base.countlines
Base.PipeBuffer
Base.readavailable
Base.IOContext
Base.IOContext(::IO, ::Pair)
Base.IOContext(::IO, ::IOContext)
```

## Text I/O

```@docs
Base.show(::IO, ::Any)
Base.summary
Base.print
Base.println
Base.printstyled
Base.sprint
Base.showerror
Base.dump
Meta.@dump
Base.readline
Base.readuntil
Base.readlines
Base.eachline
Base.copyline
Base.copyuntil
Base.displaysize
```

## [Multimedia I/O](@id Multimedia-I/O)

テキスト出力を [`print`](@ref) が行い、ユーザー定義型が [`show`](@ref) をオーバーロードすることでテキスト表現を指定できるのと同様に、Julia には、画像、書式付きテキスト、さらには音声や動画などのリッチなマルチメディア出力を行うための標準化された仕組みがあります。この仕組みは次の3つの要素から成ります。

  * Julia オブジェクト `x` を、プレーンテキストにフォールバックしつつ、利用可能な中で最もリッチな形式で表示するよう要求する関数 [`display(x)`](@ref)。
  * [`show`](@ref) をオーバーロードすると、ユーザー定義型について、標準 MIME タイプをキーとする任意のマルチメディア表現を指定できます。
  * マルチメディア対応の表示バックエンドは、汎用の [`AbstractDisplay`](@ref) 型をサブクラス化して登録し、[`pushdisplay`](@ref) を使って表示バックエンドのスタックに追加できます。

Julia の基本ランタイムが提供するのはプレーンテキスト表示のみですが、外部モジュールを読み込むか、グラフィカルな Julia 環境（IPython ベースの IJulia ノートブックなど）を使うことで、よりリッチな表示を利用できます。

```@docs
Base.AbstractDisplay
Base.Multimedia.display
Base.Multimedia.redisplay
Base.Multimedia.displayable
Base.show(::IO, ::Any, ::Any)
Base.Multimedia.showable
Base.repr(::MIME, ::Any)
Base.MIME
Base.@MIME_str
```

前述のとおり、新しい表示バックエンドを定義することもできます。たとえば、PNG 画像をウィンドウに表示できるモジュールは、その機能を Julia に登録できます。これにより、PNG 表現を持つ型に対して [`display(x)`](@ref) を呼び出すと、そのモジュールのウィンドウに画像が自動的に表示されます。

新しい表示バックエンドを定義するには、まず抽象クラス [`AbstractDisplay`](@ref) のサブタイプ `D` を作成します。次に、`D` 上で表示できる各 MIME タイプ（文字列 `mime`）について、その MIME タイプとして `x` を表示する関数 `display(d::D, ::MIME"mime", x) = ...` を定義します。通常は [`show(io, mime, x)`](@ref) または [`repr(io, mime, x)`](@ref) を呼び出します。`x` をその MIME タイプとして表示できない場合は、[`MethodError`](@ref) をスローする必要があります。`show` または `repr` を呼び出せば、これは自動的に行われます。

最後に、`D` がサポートする `mime` 型を [`showable(mime, x)`](@ref) に問い合わせ、その中から「最適な」ものを表示する関数 `display(d::D, x)` を定義します。`x` に対応する MIME タイプが見つからない場合は、`MethodError` をスローする必要があります。同様に、一部のサブタイプでは [`redisplay(d::D, ...)`](@ref Base.Multimedia.redisplay) をオーバーライドすることもできます。（繰り返しますが、`display` に新しいメソッドを追加するには、`import Base.display` する必要があります。）これらの関数の戻り値は実装に委ねられます（場合によっては、何らかの表示「ハンドル」を返すと便利なためです）。`D` の表示関数は直接呼び出すこともできますが、次のように新しい表示を表示バックエンドのスタックに追加すれば、[`display(x)`](@ref) から自動的に呼び出すこともできます。

```@docs
Base.Multimedia.pushdisplay
Base.Multimedia.popdisplay
Base.Multimedia.TextDisplay
Base.Multimedia.istextmime
```

## Network I/O

```@docs
Base.bytesavailable
Base.ntoh
Base.hton
Base.ltoh
Base.htol
Base.ENDIAN_BOM
```
