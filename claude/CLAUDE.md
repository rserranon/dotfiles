## About me

- macOS developer using Neovim, tmux, zsh, and Alacritty
- I work in two contexts: personal projects and organization work

## Personal projects

- Bitcoin Core development (regtest/signet)
- Languages: Rust, C++, Python

## Organization work

- Applications deployed on AWS (ECS, RDS PostgreSQL, S3)
- PostgreSQL RDS databases accessed via RDS Proxy
- Multiple AWS environments (OPS-QA, AISG, production)
- Infrastructure managed with CloudFormation/SAM
- Languages: TypeScript, Python

## Tech stack (shared)

- Languages: TypeScript, Rust, Python, C++
- Infrastructure: AWS (ECS, RDS, S3, SSM, CloudFormation/SAM)
- Database: PostgreSQL 15+ on RDS with RDS Proxy
- Editor: Neovim (LazyVim) with Copilot, CopilotChat, Avante

## Code style

- Concise, self-documenting code — minimal comments unless clarification needed
- Conventional commits (feat:, fix:, chore:, refactor:, docs:, test:)
- Prefer CLI tools and terminal workflows
- Smallest possible diffs when making changes

## Communication preferences

- Be concise and direct — CLI-friendly responses
- Show copy-paste ready commands
- Don't explain basics unless asked
- When suggesting changes, make the smallest possible diff

## Tool usage

- Use ripgrep (rg), fd, fzf, bat, lsd for file operations
- Use git-delta for diffs
- Prefer editing existing files over creating new ones
- Run tests and linters before considering work done

## Git workflow

- Stage changes with `git add` as part of completing work
- Always show the proposed commit message and wait for explicit approval before running `git commit`
- Only run `git commit` after the user says something like "yes", "commit", "go ahead", or "proceed"
- Do not commit autonomously even for trivial changes
