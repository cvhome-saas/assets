# QA — assets

Static files served raw from GitHub; today only the retired `fast-run` install.

- **Scope** — what a person gets when they run the published one-liner.
- **Runs on** — any shell with bash; Docker is not needed any more.
- **Cases** — 1 (1 verified, 0 not verified)
- **Also see** — the docs site's local development guide, which replaces fast-run.

## 00 — Before you start
Nothing; the script needs no root any more because it exits before doing anything.

## 01 — Retirement notice
### 01.1 fast-run prints the notice and exits non-zero [verified]
- Setup: a checkout of this repo.
- Steps: `bash fast-run/fast-run.sh; echo "exit=$?"`
- Expect: two lines on stderr naming the retirement and the lcl guide URL; `exit=1`; no change to `/etc/hosts`,
  no image pulled, no compose started.

## REG — regression watchlist
- None.

## 99 — known gaps
- The compose file still names 1.x images; it is reference material, not runnable.
