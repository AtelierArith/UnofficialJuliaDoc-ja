```julia
ttyhastruecolor()
```

Return a boolean signifying whether the current terminal supports 24-bit colors.

Multiple conditions are taken as signifying truecolor support, specifically any of the following:

  * The `COLORTERM` environment variable is set to `"truecolor"` or `"24bit"`
  * The current terminfo sets the [`RGB` capability](https://invisible-island.net/ncurses/man/user_caps.5.html#h3-Recognized-Capabilities)[^1] (or the legacy `Tc` capability[^2]) flag
  * The current terminfo provides `setrgbf` and `setrgbb` strings[^3]
  * The current terminfo has a `colors` number greater that `256`, on a unix system
  * The VTE version is at least 3600 (detected via the `VTE_VERSION` environment variable)
  * The current terminal has the `XTERM_VERSION` environment variable set
  * The current terminal appears to be iTerm according to the `TERMINAL_PROGRAM` environment variable
  * The `TERM` environment variable corresponds to: linuxvt, rxvt, or st

[^1]: Added to Ncurses 6.1, and used in `TERM=*-direct` terminfos.

[^2]: Convention [added to tmux in 2016](https://github.com/tmux/tmux/commit/427b8204268af5548d09b830e101c59daa095df9),   superseded by `RGB`.

[^3]: Proposed by [Rüdiger Sonderfeld in 2013](https://lists.gnu.org/archive/html/bug-ncurses/2013-10/msg00007.html),   adopted by a few terminal emulators.

!!! note
    The set of conditions is messy, because the situation is a mess, and there's no resolution in sight. `COLORTERM` is widely accepted, but an imperfect solution because only `TERM` is passed across `ssh` sessions. Terminfo is the obvious place for a terminal to declare capabilities, but it's taken enough years for ncurses/terminfo to declare a standard capability (`RGB`) that a number of other approaches have taken root. Furthermore, the official `RGB` capability is *incompatible* with 256-color operation, and so is unable to resolve the fragmentation in the terminal ecosystem.

