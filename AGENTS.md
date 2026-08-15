# Repository Agent Rules

## Purpose

This repository is a learning and experimentation lab for MATLAB/Simulink automation and MBD quality workflows.

## Development rules

- Do not commit generated `models/*.slx` files unless a change explicitly requires a binary fixture.
- Keep model construction reproducible from MATLAB source.
- Keep KPI calculation and requirement evaluation independent from the Simulink model when practical.
- Add tests for pure MATLAB functions before expanding orchestration.
- One logical change per pull request.

## Definition of done

A change is done when:

1. MATLAB code is syntactically consistent and functions match their filenames.
2. Existing unit tests still pass.
3. New pure calculation logic has unit coverage.
4. The README is updated when the run contract or required toolbox changes.
5. Generated outputs are not committed accidentally.
