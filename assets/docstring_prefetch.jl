# Work from actual DocStr records, including private and nested APIs such as
# LinearAlgebra.LAPACK. names(module) alone misses these documented functions.
function collect_documented_docstrings(
    mod::Module;
    seen_modules = Base.IdSet{Module}(),
    seen_docs = Base.IdSet{Base.Docs.DocStr}(),
)
    mod in seen_modules && return Base.Docs.DocStr[]
    push!(seen_modules, mod)
    docs = Base.Docs.DocStr[]
    metadata = Base.Docs.meta(mod; autoinit = false)
    if metadata !== nothing
        for multidoc in values(metadata)
            for doc in values(multidoc.docs)
                if !(doc in seen_docs)
                    push!(seen_docs, doc)
                    push!(docs, doc)
                end
            end
        end
    end
    for name in names(mod; all = true, imported = false)
        isdefined(mod, name) || continue
        Base.isdeprecated(mod, name) && continue
        child = getfield(mod, name)
        if child isa Module && child !== mod && parentmodule(child) === mod
            append!(docs, collect_documented_docstrings(child; seen_modules, seen_docs))
        end
    end
    return docs
end

function prefetch_documented_docstrings(
    mod::Module,
    translate;
    concurrency::Integer = 32,
    seen_modules = Base.IdSet{Module}(),
)
    concurrency > 0 || throw(ArgumentError("concurrency must be positive"))
    docs = collect_documented_docstrings(mod; seen_modules)
    asyncmap(docs; ntasks = concurrency) do doc
        translate(doc)
        nothing
    end
    return length(docs)
end
