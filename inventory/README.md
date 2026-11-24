# Host inventory

Captured on 2026-11-17 from `brew list --formula --versions`,
`brew list --cask --versions`, and `brew leaves`. These files describe the host;
they are not an instruction to install macOS binaries on Linux.

`packages/Brewfile.linux` covers every portable host leaf formula, plus tmux,
lsof (provided by macOS itself), and the Tree-sitter CLI required by Neovim.
macOS exclusions are dockutil, mas, pinentry-mac, and
reattach-to-user-namespace. GUI apps/casks and desktop integrations stay on the
Mac. Antidote comes from Homebrew on Linux rather than a separate checkout.

Homebrew resolves Linux builds and dependencies at install time. This does not
promise identical versions, binaries, or dependency trees across operating
systems. Standalone Node is pinned to 24.16.0, npm to 11.13.0, and Corepack to
0.35.0. Project-specific runtime selection belongs to the project's tooling or
a platform-specific shell extension.

Employer tools, internal package indexes, authentication, and machine-specific
application state belong in a separate layer. The base does not migrate
credentials, private keys, agent sessions, or protected host configuration.
