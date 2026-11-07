```julia
tarjan!(reach::CFGReachability, cfg::CFG, root::Int=1)
```

Tarjan の強連結成分アルゴリズムです。`root`からCFGを走査し、SCCが確定済みのノードを無視して、未確定のすべてのノードの出力を更新します。

到達不能なノードが見つかった場合はtrueを、そうでない場合はfalseを返します。

出力:

  * `reach.scc`:（自然）ループへの後退辺を無視した強連結成分
  * `reach.irreducible`: BasicBlockが（非自明な）SCC／既約ループの一部である場合に限りtrue
  * `reach._worklist`: 増分更新（`root != 1`）を行う場合、BasicBlock #1から到達不能な走査済みノードをこの作業リストに追加します。
