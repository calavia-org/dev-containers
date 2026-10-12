# dev-containers — Agent Instructions

> **MANDATORY READ**: This repository is governed by [`~/Development/Github/AGENTS.md`](../AGENTS.md) (organization-wide rules). Per-repo rules below provide project-specific details but **cannot override** organization rules.

## Project Overview

Hosts a shared base dev container image used across `calavia-org` repositories. The image builds on `mcr.microsoft.com/devcontainers/base:alpine` and adds tooling every repo needs (pre-commit, semantic-release, Node.js, Python/pip).

## Repository Layout

```
.
├── Dockerfile                       # Base image definition (alpine + pre-commit + semantic-release)
├── .devcontainer/
│   └── devcontainer.json            # Local dev environment (Docker-in-Docker + actionlint)
├── .github/
│   ├── dependabot.yml               # Dependency update automation
│   └── workflows/
│       ├── build-container.yml      # Builds the base image on PRs to main
│       └── pr-check-and-test.yml    # Org-standard PR checks (reusable workflow)
├── LICENSE
└── README.md
```

## Tech Stack

- **Language**: Dockerfile (Alpine), JSON (devcontainer), YAML (workflows)
- **Base image**: `mcr.microsoft.com/devcontainers/base:alpine`
- **Tooling baked into image**: `pre-commit`, `semantic-release`, `nodejs`, `npm`, `py3-pip`
- **CI**: reusable workflows from `calavia-org/workflows-lib`

## Environment Setup

```bash
# Open the repository in VS Code with the Dev Containers extension; the
# .devcontainer/devcontainer.json provisions a Docker-in-Docker environment
# with actionlint preinstalled.

# Or build the base image directly
docker build -t devcontainer-base:local .
```

## Linting & Formatting

```bash
# Run all hooks (yaml checks, markdownlint, actionlint, whitespace)
pre-commit run --all-files
```

## Testing

There is no unit/integration test suite. Validation happens two ways:

```bash
# 1. Pre-commit hooks lint Dockerfile-adjacent files and workflows
pre-commit run --all-files

# 2. The build-container.yml workflow proves the image actually builds on PRs
#    (see .github/workflows/build-container.yml)
```

## CI/CD

- **PR checks**: `.github/workflows/pr-check-and-test.yml` calls `calavia-org/workflows-lib/.github/workflows/pr-check-and-test.yml@v0` (pre-commit only — `run-build`, `run-unit-tests`, `run-integration-tests` are all `false`).
- **Image build**: `.github/workflows/build-container.yml` calls `calavia-org/workflows-lib/.github/workflows/build-container.yml@main` and builds `Dockerfile` into the `devcontainer-base` image on every PR to `main`.
- **Release**: none — this repo publishes a container image, not a versioned artifact.

## Key Commands

| Task | Command |
|------|---------|
| Build base image locally | `docker build -t devcontainer-base:local .` |
| Run pre-commit hooks | `pre-commit run --all-files` |
| Lint workflows | `actionlint .github/workflows/*.yml` |

## Gotchas & Special Cases

- The `Dockerfile` uses `pip install --break-system-packages` because Alpine's Python is externally managed (PEP 668). Do not remove that flag.
- `semantic-release` is installed globally via `npm` in the image; consumers of the base image rely on it being on `PATH`.
- The repo dogfoods its own image: `devcontainer.json` does not reference the produced image directly (it uses the upstream `base:bullseye` + features), because the produced image is for *other* repos to consume.
- `build-container.yml` pins `@main` of `workflows-lib` while `pr-check-and-test.yml` pins `@v0`. This mirrors the existing convention; do not change it in this PR.

## Commits & Branches

- All commits follow [Conventional Commits](https://www.conventionalcommits.org/) (`feat:`, `fix:`, `chore:`, `docs:` …).
- Branches use conventional prefixes: `feat/`, `fix/`, `chore/`, `docs/`, `ci/`.
- Never commit directly to `main` — every change goes through a PR (squash merge only).

## References

- **README.md**: brief repo purpose
- **Org harness**: `~/Development/Github/AGENTS.md` — organization-wide rules
- **workflows-lib**: `calavia-org/workflows-lib` — reusable CI workflows
- **org-standards**: `calavia-org/org-standards` — canonical templates and manifest

---

**Last Updated**: 2026-10-12
**Maintained By**: calavia-org
