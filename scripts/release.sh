#!/usr/bin/env bash
set -euo pipefail

# release.sh — CalVer release script for typst-DIN5008a
# Usage:
#   ./scripts/release.sh dev          — dev pre-release on dev branch
#   ./scripts/release.sh prod         — merge dev -> main, tag, push
#   ./scripts/release.sh prod --new-month  — advance CalVer month

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
PROJECT_DIR="$(dirname "$SCRIPT_DIR")"
cd "$PROJECT_DIR"

MODE="${1:-}"
FLAG="${2:-}"

if [[ -z "$MODE" ]]; then
    echo "Usage: $0 {dev|prod} [--new-month]"
    echo ""
    echo "  dev           dev pre-release (.devN) on dev branch"
    echo "  prod          merge dev -> main, tag, push"
    echo "  prod --new-month  advance CalVer month first"
    echo ""
    bump-my-version show-bump 2>/dev/null || true
    exit 1
fi

# Ensure working tree is clean
if [[ -n "$(git status --porcelain)" ]]; then
    echo "error: working tree is not clean"
    exit 1
fi

case "$MODE" in
    dev)
        BRANCH="$(git branch --show-current)"
        if [[ "$BRANCH" != "dev" ]]; then
            echo "error: must be on dev branch (currently on $BRANCH)"
            exit 1
        fi
        bump-my-version bump dev
        git push && git push --tags
        echo "dev release done: $(grep -o '"[^"]*"' version.typ | tr -d '"')"
        ;;

    prod)
        BRANCH="$(git branch --show-current)"
        if [[ "$BRANCH" != "dev" ]]; then
            echo "error: must be on dev branch (currently on $BRANCH)"
            exit 1
        fi

        if [[ "$FLAG" == "--new-month" ]]; then
            bump-my-version bump minor
        else
            bump-my-version bump patch
        fi

        VERSION="$(grep -o '"[^"]*"' version.typ | tr -d '"')"

        # Merge dev -> main
        git checkout main
        git merge dev --no-ff -m "release: merge dev for v$VERSION"
        git push && git push --tags

        # Back to dev
        git checkout dev
        echo "prod release done: v$VERSION"
        ;;

    *)
        echo "error: unknown mode '$MODE' (use dev or prod)"
        exit 1
        ;;
esac
