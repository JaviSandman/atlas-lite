# Publish Atlas Lite v0.1.0 on GitHub (Windows)

## 1. Final local checks

```powershell
powershell -ExecutionPolicy Bypass -File .\installer\windows\atlas-doctor.ps1
```

Expected: `Atlas Doctor: PASS`

## 2. Commit and push

```powershell
git add .
git commit -m "release: atlas lite v0.1.0 windows installer"
git push
```

## 3. Create tag and release

```powershell
git tag v0.1.0
git push origin v0.1.0
```

Then in GitHub UI:
1. Open Releases.
2. Create release from tag `v0.1.0`.
3. Title: `Atlas Lite v0.1.0`.
4. Add release notes with install steps and known limitations.

## 4. What students do

1. Download ZIP from GitHub release.
2. Extract folder.
3. Run:

```powershell
powershell -ExecutionPolicy Bypass -File .\installer\windows\install-atlas.ps1
```

4. Start using Atlas in VS Code.
