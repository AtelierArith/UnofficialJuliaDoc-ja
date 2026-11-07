```julia
iterated_dominance_frontier(cfg::CFG, liveness::BlockLiveness, domtree::DomTree)
    -> phinodes::Vector{Int}
```

反復支配フロンティアを求めます。ここで使うアルゴリズムは基本的にLLVMに従っています。LLVMのアルゴリズム自体も、[^SG95]で説明されている線形時間アルゴリズムを整理したものです。

ここでのアルゴリズムは非常に単純です。次のCFGがあるとします。

```julia
A -> B -> D -> F
 \-> C ------>/
```

これに対応する支配木は次のとおりです。

```julia
A
|- B - D
|- C
|- F
```

対象スロットの定義ごとに、支配木を下向きにたどり、その定義を根とする部分支配木から出る辺を探します。

上の例で、`B`に定義があるとします。その後続ブロックは`D`だけで、これは`B`に支配されているため、ϕノードは必要ありません。次に、`B`を根とする部分木を下っていくと、`D`にたどり着きます。`D`の後続ブロックは`F`ですが、これは現在の部分木に含まれていません（つまり、`B`に支配されていません）。したがって、ϕノードが必要です。

このアルゴリズムの重要な着眼点は、`A`と`B`の2つのブロックに定義があり、`A`が`B`を支配している場合、`B`を再帰的に調べる必要がないことです。`B`を根とする部分木から外へ出る辺の候補集合は、`A`を根とする部分木（`A`を根とする部分木の外側）から出る辺の候補集合の真部分集合だからです。ただし、逆方向には成り立たない点に注意してください。そのため、このアルゴリズムでは、必ず`B`を`A`より先に訪問する必要があります。

[^SG95]: Vugranam C. Sreedhar and Guang R. Gao. 1995.      A linear time algorithm for placing φ-nodes.      In Proceedings of the 22nd ACM SIGPLAN-SIGACT symposium on Principles of programming languages (POPL '95).      Association for Computing Machinery, New York, NY, USA, 62–73.      DOI: ['h': ASCII/Unicode U+0068 (category Ll: Letter, lowercase)'t': ASCII/Unicode U+0074 (category Ll: Letter, lowercase)'t': ASCII/Unicode U+0074 (category Ll: Letter, lowercase)'p': ASCII/Unicode U+0070 (category Ll: Letter, lowercase)'s': ASCII/Unicode U+0073 (category Ll: Letter, lowercase)':': ASCII/Unicode U+003A (category Po: Punctuation, other)'/': ASCII/Unicode U+002F (category Po: Punctuation, other)'/': ASCII/Unicode U+002F (category Po: Punctuation, other)'d': ASCII/Unicode U+0064 (category Ll: Letter, lowercase)'o': ASCII/Unicode U+006F (category Ll: Letter, lowercase)'i': ASCII/Unicode U+0069 (category Ll: Letter, lowercase)'.': ASCII/Unicode U+002E (category Po: Punctuation, other)'o': ASCII/Unicode U+006F (category Ll: Letter, lowercase)'r': ASCII/Unicode U+0072 (category Ll: Letter, lowercase)'g': ASCII/Unicode U+0067 (category Ll: Letter, lowercase)'/': ASCII/Unicode U+002F (category Po: Punctuation, other)'1': ASCII/Unicode U+0031 (category Nd: Number, decimal digit)'0': ASCII/Unicode U+0030 (category Nd: Number, decimal digit)'.': ASCII/Unicode U+002E (category Po: Punctuation, other)'1': ASCII/Unicode U+0031 (category Nd: Number, decimal digit)'1': ASCII/Unicode U+0031 (category Nd: Number, decimal digit)'4': ASCII/Unicode U+0034 (category Nd: Number, decimal digit)'5': ASCII/Unicode U+0035 (category Nd: Number, decimal digit)'/': ASCII/Unicode U+002F (category Po: Punctuation, other)'1': ASCII/Unicode U+0031 (category Nd: Number, decimal digit)'9': ASCII/Unicode U+0039 (category Nd: Number, decimal digit)'9': ASCII/Unicode U+0039 (category Nd: Number, decimal digit)'4': ASCII/Unicode U+0034 (category Nd: Number, decimal digit)'4': ASCII/Unicode U+0034 (category Nd: Number, decimal digit)'8': ASCII/Unicode U+0038 (category Nd: Number, decimal digit)'.': ASCII/Unicode U+002E (category Po: Punctuation, other)'1': ASCII/Unicode U+0031 (category Nd: Number, decimal digit)'9': ASCII/Unicode U+0039 (category Nd: Number, decimal digit)'9': ASCII/Unicode U+0039 (category Nd: Number, decimal digit)'4': ASCII/Unicode U+0034 (category Nd: Number, decimal digit)'6': ASCII/Unicode U+0036 (category Nd: Number, decimal digit)'4': ASCII/Unicode U+0034 (category Nd: Number, decimal digit)](https://doi.org/10.1145/199448.199464).
