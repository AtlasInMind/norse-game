# Deployment

## Purpose

Document how the web build is actually published, and what was verified about the chosen host — see GitHub issue #32.

## Hosting choice: GitHub Pages

Chosen for zero additional accounts/credentials (the project already lives in this GitHub repo), at the cost of the repo being public — see `docs/DECISIONS.md` for the record of that trade-off being made explicitly with the client. Alternatives considered (Netlify, Vercel, Cloudflare Pages) would have allowed keeping the repo private, but each requires creating and connecting a separate third-party account.

**Live URL:** https://atlasinmind.github.io/norse-game/

## How it works

- The actual game content is served from the `gh-pages` branch (root), which contains *only* the exported web build (`index.html`, `index.js`, `index.wasm`, `index.pck`, icons, `.nojekyll`) — not the project source. This branch has no history in common with `main`; it's an orphan branch that gets replaced wholesale on each deploy.
- GitHub auto-detected the `gh-pages` branch on first push and enabled Pages against it automatically (confirmed via `gh api repos/AtlasInMind/norse-game/pages`) — no separate "enable Pages" step was needed once the branch existed with content at its root.

## How to redeploy after a change

From the `game/` directory, with a clean `main` working tree:

```sh
mkdir -p ../builds/web
godot --headless --export-release "Web" ../builds/web/index.html
```

Then, from the repo root, publish that output to `gh-pages` via a disposable worktree (keeps `main`'s working tree untouched):

```sh
git worktree add -B gh-pages-update /tmp/norse-game-ghpages-update gh-pages
rm -rf /tmp/norse-game-ghpages-update/*
cp -r builds/web/* /tmp/norse-game-ghpages-update/
cd /tmp/norse-game-ghpages-update
git add -A
git commit -m "Update web export"
git push origin gh-pages-update:gh-pages
cd - && git worktree remove /tmp/norse-game-ghpages-update --force && git branch -D gh-pages-update
```

(`-B` instead of `-b` on `worktree add` re-creates the local `gh-pages-update` branch if it's left over from a prior run, and the trailing `git branch -D` cleans it up afterward — `worktree remove` only removes the worktree directory, not the branch, so without that cleanup step the *next* redeploy's `git worktree add -b ...` would fail with "a branch named 'gh-pages-update' already exists.")

This is a manual process, not yet automated via GitHub Actions. A CI-driven deploy (build + publish on every push to `main`) would remove the manual step, but needs Godot + its export templates available in CI (~1.2GB template download, see `README.md`'s local setup notes for the same requirement) — worth doing once deploys become frequent enough to be worth the setup cost, not before.

## Verified in production (2026-07-25)

- **The deployed build actually loads and runs**: verified via Playwright/Chromium against the live URL — main menu renders correctly, zero console/page errors.
- **Compression: GitHub Pages serves gzip, but not Brotli.** Checked directly against the live URL:
  - `curl -H "Accept-Encoding: gzip" ... index.wasm` → `content-encoding: gzip` header present, 10,248,573 bytes downloaded (close to the ~10.05MB local `gzip -9` measurement in `research/web_export_findings.md`).
  - `curl -H "Accept-Encoding: br" ... index.wasm` → **no** `content-encoding` header at all; the full 39,513,091-byte uncompressed file is returned. GitHub Pages' CDN (Fastly) does not serve Brotli for this content, at least not as configured by default Pages hosting — this could not have been discovered without testing live, and contradicts the general assumption in `research/web_export_findings.md` that "most modern static hosting services... do this automatically." It doesn't for this specific case.
  - Real-world consequence: browsers requesting the live game get the gzip-compressed ~10.2MB `.wasm`, not the theoretical best (brotli, ~6.9MB) measured locally in issue #28.
- **Real boot-to-menu time, measured against the actual live URL** (Playwright/Chromium, CDP `Network.emulateNetworkConditions`):

| Scenario | Boot-to-menu time |
|---|---|
| Live GitHub Pages, simulated ~10 Mbps/40ms | **9.37s** — closely matches the local gzip-server measurement (10.1s) from issue #28, confirming that local measurement was a realistic stand-in for this host. |
| Live GitHub Pages, unthrottled | 1.14s |

**Takeaway:** GitHub Pages is a working, zero-cost hosting solution that meaningfully improves load time over uncompressed serving (10.2MB vs 39.5MB, ~9.4s vs ~32.7s on a throttled connection), but it does not reach the Brotli-compressed ~6.9MB/~6.4s result measured locally in issue #28. If load time on slow connections becomes a real product concern later (e.g. once real audio/art assets add meaningfully to the payload), switching to a host with confirmed Brotli support (Netlify, Vercel, and Cloudflare Pages are commonly cited as supporting it) is the concrete lever to pull — not a re-litigation of this measurement.

## Sources/methodology

- `docs/research/web_export_findings.md` — original compression measurements and methodology this deployment's verification directly compares against.
- Measured 2026-07-25, same Playwright/Chromium CDP-throttling method used throughout M4's performance work.

## Last updated

2026-07-25
