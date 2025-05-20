# External Profiler Support

Juliaは、外部トレースプロファイラに対する明示的なサポートを提供しており、ランタイムの実行動作の高レベルな概要を取得することができます。

現在サポートされているプロファイラーは次のとおりです：

  * [Tracy](https://github.com/wolfpld/tracy)
  * [Intel VTune (ITTAPI)](https://github.com/intel/ittapi)

### Adding New Zones

新しいゾーンを追加するには、`JL_TIMING` マクロを使用します。コードベース全体で `JL_TIMING` を検索することで、多くの例を見つけることができます。新しいタイプのゾーンを追加するには、それを `JL_TIMING_OWNERS` に追加します（おそらく `JL_TIMING_EVENTS` にも）。

### Dynamically Enabling and Disabling Zones

[`JULIA_TIMING_SUBSYSTEMS`](@ref JULIA_TIMING_SUBSYSTEMS) 環境変数を使用すると、特定の Julia 実行のためにゾーンを有効または無効にすることができます。たとえば、変数を `+GC,-INFERENCE` に設定すると、`GC` ゾーンが有効になり、`INFERENCE` ゾーンが無効になります。

## Tracy Profiler

[Tracy](https://github.com/wolfpld/tracy) は、オプションでJuliaに統合できる柔軟なプロファイラです。

典型的なTracyセッションは次のようになります：

![典型的なTracyの使用法](tracy.png)

### Building Julia with Tracy

Tracy統合を有効にするには、`Make.user`ファイルに追加オプション`WITH_TRACY=1`を指定してJuliaをビルドします。

### Installing the Tracy Profile Viewer

プロファイルビューアを取得する最も簡単な方法は、`TracyProfiler_jll` パッケージを追加し、次のコマンドでプロファイラを起動することです:

```julia
run(TracyProfiler_jll.tracy())
```

!!! note
    macOSでは、プロファイラーのUI要素が過度に大きく表示される場合、`TRACY_DPI_SCALE`環境変数を`1.0`に設定することをお勧めします。


「ヘッドレス」インスタンスを実行してトレースをディスクに保存するには、次のようにします。

```julia
run(`$(TracyProfiler_jll.capture()) -o mytracefile.tracy`)
```

その代わりに。

Tracy UIの使用に関する情報は、Tracyマニュアルを参照してください。

### Profiling Julia with Tracy

トレイシーでジュリアのプロファイリングを行う典型的なワークフローは、次のようにジュリアを起動することから始まります：

```julia
JULIA_WAIT_FOR_TRACY=1 ./julia -e '...'
```

環境変数は、JuliaがTracyプロファイラに正常に接続するまで待機することを保証します。その後、TracyプロファイラのUIを使用して`Connect`をクリックすると、Juliaの実行が再開され、プロファイリングが開始されるはずです。

### Profiling package precompilation with Tracy

パッケージのプリコンパイルプロセスをプロファイルするには、プリコンパイルしたいパッケージを指定して `Base.compilecache` を明示的に呼び出すのが最も簡単です：

```julia
pkg = Base.identify_package("SparseArrays")
withenv("JULIA_WAIT_FOR_TRACY" => 1, "TRACY_PORT" => 9001) do
    Base.compilecache(pkg)
end
```

ここでは、Tracyのカスタムポートを使用しており、Tracy UIで接続する正しいクライアントを見つけやすくしています。

### Adding metadata to zones

さまざまな `jl_timing_show_*` および `jl_timing_printf` 関数を使用して、ゾーンに文字列（または文字列群）を添付することができます。たとえば、推論のトレースゾーンは、推論されているメソッドインスタンスを表示します。

`TracyCZoneColor` 関数は、特定のゾーンの色を設定するために使用できます。コードベースを検索して、どのように使用されているかを確認してください。

### Viewing Tracy files in your browser

https://topolarity.github.io/trace-viewer/ にアクセスして、Tracyトレース用の（実験的な）Webビューワーをご覧ください。

ローカルの `.tracy` ファイルを開くか、ウェブからの URL を提供できます（例：Github リポジトリ内のファイル）。ウェブからトレースファイルを読み込む場合、他の人とページの URL を直接共有することもでき、同じトレースを表示できるようになります。

### Enabling stack trace samples

Tracyでコールスタックサンプリングを有効にするには、`Make.user`ファイルに以下のオプションを指定してJuliaをビルドしてください：

```
WITH_TRACY := 1
WITH_TRACY_CALLSTACKS := 1
USE_BINARYBUILDER_LIBTRACYCLIENT := 0
```

`make -C deps clean-libtracyclient` を実行して、Tracyの再ビルドを強制する必要があるかもしれません。

この機能はトレースサイズとプロファイリングオーバーヘッドに大きな影響を与えるため、特にトレースファイルをオンラインで共有する予定がある場合は、可能な限りコールスタックサンプリングをオフにしておくことをお勧めします。

JuliaのJITランタイムはまだTracyのシンボル化との統合を持っていないため、Juliaの関数は通常、これらのスタックトレースでは不明となります。

## Intel VTune (ITTAPI) Profiler

*このセクションはまだ書かれていません。*
