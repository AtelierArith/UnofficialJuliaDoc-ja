```julia
__has_internal_change(version_or::VersionNumber, change_name::Symbol)
```

Some Julia packages have known dependencies on Julia internals (e.g. for introspection of internal julia datastructures). To ease the co-development of such packages with julia, a `change_name` is assigned on a best-effort basis or when explicitly requested. This `change_name` can be used to probe whether or not the particular pre-release build of julia has a particular change. In particular this function tests change scheduled for `version_or` is present in our current julia build, either because our current version is greater than `version_or` or because we're running a pre-release build that includes the change.

Using this mechanism is a superior alternative to commit-number based `VERSION` comparisons, which can be brittle during pre-release stages when there are multiple actively developed branches.

The list of changes is cleared twice during the release process:

1. With the release of the first alpha
2. For the first release candidate

No new `change_name`s will be added during release candidates or bugfix releases (so in particular on any released version, the list of changes will be empty and `__has_internal_change` will always be equivalent to a version comparison.

# Example

Julia version `v"1.12.0-DEV.173"` changed the internal representation of line number debug info. Several debugging packages have custom code to display this information and need to be changed accordingly. In previous practice, this would often be accomplished with something like the following

```julia
@static if VERSION > v"1.12.0-DEV.173"
    # Code to handle new format
else
    # Code to handle old format
end
```

However, because such checks cannot be introduced until a VERSION number is assigned (which also automatically pushes out the change to all nightly users), there was a builtin period of breakage. With `__has_internal_change`, this can instead be written as:

```julia
@static if __has_internal_change(v"1.12-alpha", :invertedlinenames)
    # Code to handle new format
else
    # Code to handle old format
end
```

To find out the correct verrsion to use as the first argument, you may use `Base.__next_removal_version`, which is set to the next version number in which the list of changes will be cleared.

The primary advantage of this approach is that it allows a new version of the package to be tagged and released *in advance* of the break on the nightly build, thus ensuring continuity of package operation for nightly users.

!!! warning
    This functionality is intended to help package developers which make use of internal julia functionality. Doing so is explicitly discouraged unless absolutely required and comes with the explicit understanding that the package will break. In particular, this is not a generic feature-testing mechanism, but only a simple, courtesy coordination mechanism for changes that are known (or found) to be breaking a package depending on julia internals.

