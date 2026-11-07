# [Memory Management and Garbage Collection](@id man-memory-management)

Juliaは、組み込みのガベージコレクター（GC）によってメモリを自動管理します。このセクションでは、Juliaのメモリ管理の概要と、アプリケーションのメモリ使用量を設定・最適化する方法を説明します。

## [Garbage Collection Overview](@id man-gc-overview)

Juliaのガベージコレクターには、次のような特徴があります。

  * **非移動型**: ガベージコレクション中にオブジェクトがメモリ上で移動することはありません
  * **世代別**: 古いオブジェクトよりも新しいオブジェクトを頻繁に回収します
  * **並列かつ部分的に並行**: GCは複数のスレッドを使用でき、プログラムの実行と並行して動作します
  * **ほぼ正確**: 純粋なJuliaコードではオブジェクト参照を正確に特定し、CからJuliaを呼び出すユーザー向けには保守的スキャンAPIを提供します

ガベージコレクターは、プログラムから到達できなくなったオブジェクトが使用していたメモリを自動的に回収します。そのため、ほとんどの場合、手動でメモリを管理する必要はありません。

## [Memory Architecture](@id man-memory-architecture)

Juliaでは、次の2段階の割り当て方式を採用しています。

  * **小さなオブジェクト**（現在は2032バイト以下ですが、変更される可能性があります）: スレッドごとの高速なプールアロケーターを使って割り当てます
  * **大きなオブジェクト**: システムの`malloc`を介して直接割り当てます

このハイブリッド方式は、割り当て速度とメモリ効率の両方を最適化します。プールアロケーターにより、Juliaプログラムで一般的な多数の小さなオブジェクトを高速に割り当てられます。

## [System Memory Requirements](@id man-system-memory)

### Swap Space

Juliaのガベージコレクターは、システムに十分なスワップ領域が設定されていることを前提に設計されています。GCのヒューリスティックは、必要に応じて物理RAMを超えるメモリを割り当てられるものと想定し、オペレーティングシステムの仮想メモリ管理に依存します。

システムのスワップ領域が少ない、またはまったくない場合、ガベージコレクション中にメモリ不足エラーが発生することがあります。その場合は、`--heap-size-hint`オプションを使ってJuliaのメモリ使用量を制限できます。

### Memory Hints

Juliaに、使用するメモリの最大量をヒントとして指定できます。

```bash
julia --heap-size-hint=4G  # To set the hint to ~4GB
julia --heap-size-hint=50% # or to 50% of physical memory
```

`--heap-size-hint`オプションを指定すると、設定した上限に近づいたときに、ガベージコレクターがより積極的に回収を開始します。特に、次のような環境で役立ちます。

  * メモリ制限のあるコンテナ
  * スワップ領域のないシステム
  * Juliaのメモリ使用量を制限したい共有システム

`JULIA_HEAP_SIZE_HINT`環境変数を使って設定することもできます。

```bash
export JULIA_HEAP_SIZE_HINT=2G
julia
```

## [Multithreaded Garbage Collection](@id man-gc-multithreading)

Juliaのガベージコレクターは、マルチコアシステムで複数のスレッドを活用し、性能を向上させることができます。

### GC Thread Configuration

デフォルトでは、Juliaはガベージコレクションに複数のスレッドを使用します。

  * **マークスレッド**: マークフェーズでオブジェクト参照をたどるために使用します（デフォルトは1。計算スレッドが1つの場合はそのスレッドと共有し、それ以外の場合は計算スレッド数の半分です）
  * **スイープスレッド**: 解放済みメモリを並行してスイープするために使用します（デフォルトは0で、無効です）

GCのスレッド数は、次の方法で設定できます。

```bash
julia --gcthreads=4,1  # 4 mark threads, 1 sweep thread
julia --gcthreads=8    # 8 mark threads, 0 sweep threads
```

または、環境変数で設定できます。

```bash
export JULIA_NUM_GC_THREADS=4,1
julia
```

### Recommendations

計算負荷の高いワークロードでは、次の点を検討してください。

  * マークスレッドを複数使用する（通常はデフォルト設定が適切です）
  * 割り当ての多いワークロードでは、スイープスレッドを1つにして並行スイープを有効にする

メモリ負荷の高いワークロードでは、次の点を検討してください。

  * 並行スイープを有効にして、GCによる一時停止を短縮する
  * `@time`を使ってGCにかかる時間を監視し、それに応じてスレッド数を調整する

## [Monitoring and Debugging](@id man-gc-monitoring)

### Basic Memory Monitoring

`@time`マクロを使うと、メモリ割り当て量とGCのオーバーヘッドを確認できます。

```julia
julia> @time some_computation()
  2.123456 seconds (1.50 M allocations: 58.725 MiB, 17.17% gc time)
```

### GC Logging

GCの動作パターンを把握するには、詳細なGCログを有効にします。

```julia
julia> GC.enable_logging(true)
julia> # Run your code
julia> GC.enable_logging(false)
```

各ガベージコレクションのイベントについて、所要時間とメモリ統計が記録されます。

### Manual GC Control

一般には推奨されませんが、ガベージコレクションを手動で実行することもできます。

```julia
GC.gc()          # Force a garbage collection
GC.enable(false) # Disable automatic GC (use with caution!)
GC.enable(true)  # Re-enable automatic GC
```

**警告**: GCを無効にすると、メモリを使い果たすおそれがあります。特定の性能測定やデバッグに限って使用してください。

## [Performance Considerations](@id man-gc-performance)

### Reducing Allocations

GCの影響を最小限に抑えるには、不要なメモリ割り当てを減らすのが最も効果的です。

  * 可能な場合は、インプレース操作を使います（例: `x = x + y`の代わりに`x .+= y`を使う）
  * 配列を事前に確保し、再利用する
  * ループ内で一時オブジェクトを作成しない
  * 小さくサイズが固定された配列には、`StaticArrays.jl`の使用を検討する

### Memory-Efficient Patterns

  * 型が変わるグローバル変数は避ける
  * グローバル定数には`const`を使う

### Profiling Memory Usage

メモリ割り当てのプロファイリングや性能上のボトルネックの特定について詳しくは、[Profiling](@ref lib-profiling)セクションを参照してください。

## [Advanced Configuration](@id man-gc-advanced)

### Integration with System Memory Management

Juliaを快適に動作させるには、次の条件が整っていることが望まれます。

  * 十分なスワップ領域がある（推奨値: 物理RAMの2倍）
  * 仮想メモリが適切に設定されている
  * 他のプロセスが十分なメモリを残している
  * コンテナのメモリ制限が`--heap-size-hint`で適切に設定されている

## [Troubleshooting Memory Issues](@id man-gc-troubleshooting)

### High GC Overhead

ガベージコレクションに時間がかかりすぎる場合は、次の方法を試してください。

1. **割り当て頻度を下げる**: アルゴリズムの改善に注力する
2. **GCスレッド数を調整する**: `--gcthreads`の設定を変えて試す
3. **並行スイープを使う**: `--gcthreads=N,1`でバックグラウンドスイープを有効にする
4. **メモリ使用パターンをプロファイリングする**: 割り当てが集中する箇所を特定して最適化する

### Memory Leaks

JuliaのGCはほとんどのメモリリークを防ぎますが、次のような問題が起こることはあります。

  * **グローバル参照**: 大きなオブジェクトへの参照をグローバル変数に保持しない
  * **クロージャ**: 大量のデータをキャプチャするクロージャに注意する
  * **Cとの相互運用**: Cライブラリとの連携時には、適切にクリーンアップする

Juliaのガベージコレクターの内部動作について詳しくは、開発者向けドキュメントの「ガベージコレクション」セクションを参照してください。
