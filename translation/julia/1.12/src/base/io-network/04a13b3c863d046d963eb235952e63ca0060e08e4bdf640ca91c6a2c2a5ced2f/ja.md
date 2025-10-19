# I/O and Network

## General I/O

```@docs
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

テキスト出力は [`print`](@ref) によって行われ、ユーザー定義型は [`show`](@ref) をオーバーロードすることでそのテキスト表現を示すことができます。Juliaは、画像、フォーマットされたテキスト、さらには音声や動画などのリッチマルチメディア出力のための標準化されたメカニズムを提供しており、これには3つの部分が含まれています。

  * 関数 [`display(x)`](@ref) は、プレーンテキストのフォールバックを使用して、Juliaオブジェクト `x` の最もリッチな利用可能なマルチメディア表示を要求します。
  * [`show`](@ref) のオーバーロードにより、ユーザー定義型の任意のマルチメディア表現（標準MIMEタイプによってキー付けされた）を示すことができます。
  * マルチメディア対応のディスプレイバックエンドは、一般的な [`AbstractDisplay`](@ref) タイプをサブクラス化することで登録でき、[`pushdisplay`](@ref) を介してディスプレイバックエンドのスタックにプッシュされます。

基本的なJuliaランタイムはプレーンテキストの表示のみを提供しますが、外部モジュールをロードするか、グラフィカルなJulia環境（IPythonベースのIJuliaノートブックなど）を使用することで、よりリッチな表示を有効にすることができます。

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

As mentioned above, one can also define new display backends. For example, a module that can display PNG images in a window can register this capability with Julia, so that calling [`display(x)`](@ref) on types with PNG representations will automatically display the image using the module's window.

新しいディスプレイバックエンドを定義するには、まず抽象クラス [`AbstractDisplay`](@ref) のサブタイプ `D` を作成する必要があります。次に、`D` で表示できる各 MIME タイプ（`mime` 文字列）について、`display(d::D, ::MIME"mime", x) = ...` という関数を定義し、通常は [`show(io, mime, x)`](@ref) または [`repr(io, mime, x)`](@ref) を呼び出すことで、`x` をその MIME タイプとして表示します。`x` がその MIME タイプとして表示できない場合は、[`MethodError`](@ref) をスローする必要があります。これは、`show` または `repr` を呼び出すと自動的に行われます。最後に、`display(d::D, x)` という関数を定義し、[`showable(mime, x)`](@ref) に対して `D` がサポートする `mime` タイプを照会し、「最適な」ものを表示します。`x` に対してサポートされている MIME タイプが見つからない場合は、`MethodError` をスローする必要があります。同様に、一部のサブタイプは [`redisplay(d::D, ...)`](@ref Base.Multimedia.redisplay) をオーバーライドしたい場合があります。（再度、`import Base.display` を使用して `display` に新しいメソッドを追加する必要があります。）これらの関数の戻り値は実装に依存します（場合によっては、何らかのタイプのディスプレイ「ハンドル」を返すことが有用な場合があります）。その後、`D` のディスプレイ関数は直接呼び出すことができますが、次のようにディスプレイバックエンドスタックに新しいディスプレイをプッシュすることで、[`display(x)`](@ref) から自動的に呼び出すこともできます。

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
