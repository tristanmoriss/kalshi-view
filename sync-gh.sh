#!/bin/bash
set -e
REPO="kalshi-view"
DIR="/Users/tristanmorissette/.hermes/profiles/kalshi/workspace/gh-pages"
cd "$DIR"
if [ ! -d .git ]; then git init -q; git branch -m main; git remote add origin "https://github.com/tristanmoriss/$REPO.git" 2>/dev/null || true; fi
git config user.name >/dev/null 2>&1 || git config user.name tristanmorissette
git config user.email >/dev/null 2>&1 || git config user.email tristancareers9@gmail.com
if git fetch -q origin main 2>/dev/null; then
  if git show origin/main:settings.json > /tmp/k_settings.json 2>/dev/null; then
    python3 -c "
import json
d=json.load(open('/Users/tristanmorissette/.hermes/profiles/kalshi/workspace/settings.json'))
r=json.load(open('/tmp/k_settings.json'))
if r.get('risk_level') and r['risk_level']!=d.get('risk_level'):
    d['risk_level']=r['risk_level']
    json.dump(d,open('/Users/tristanmorissette/.hermes/profiles/kalshi/workspace/settings.json','w'),indent=1)
    print('risk merged from phone:',r['risk_level'])
"
    cp ../settings.json settings.json
  fi
fi
git add -A; git commit -qm "kalshi snapshot $(date '+%m-%d %H:%M')" || echo "no changes"
git push -q -u origin main 2>&1 | tail -1 || true
export PATH="$PATH:/Users/tristanmorissette/.hermes/tools/bin"
gh api -X POST repos/tristanmoriss/$REPO/pages/builds >/dev/null 2>&1 || true
echo "kalshi-view synced"
