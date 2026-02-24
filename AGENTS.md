# AGENTS.md

Guidance for coding agents working in this repository.

## Scope

This file applies to the entire repository rooted at this directory.

## Project facts

- Main application code is under `public/`.
- Runtime entrypoint is `public/index.js`, which bootstraps `public/app.coffee`.
- Backend and frontend are both legacy CoffeeScript-era code.

## Safe workflow

1. Read `README.md` first for architecture and setup context.
2. Prefer targeted, minimal edits over broad refactors.
3. Keep compatibility with existing CoffeeScript/Jade/AngularJS patterns.
4. Avoid introducing modern build tooling unless explicitly requested.

## Validation checklist

When making changes, run what is feasible:

- `npm --prefix public install`
- `npm --prefix public run concat`

If runtime validation is required and possible:

- ensure `public/.env` exists,
- run `npm --prefix public start`.

## Documentation expectations

- Update `README.md` when behavior, setup, or architecture descriptions change.
- Prefer documenting legacy constraints explicitly (old dependencies, Node compatibility caveats).
