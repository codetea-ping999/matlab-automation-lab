# MATLAB Automation Lab

MATLAB/Simulink automation lab for model-based development workflows.

## v0.1 goal

Run one command and automate the complete loop:

```text
parameters.csv
    -> build Quarter-car Simulink model
    -> run parameter sweep
    -> calculate KPIs
    -> evaluate requirements
    -> write CSV + Markdown report
```

The Simulink model is generated from MATLAB source instead of committing a binary `.slx` file, so the model architecture remains reviewable in Git.

## Requirements

- MATLAB
- Simulink

No Report Generator or Parallel Computing Toolbox is required for v0.1.

## Run

From the repository root:

```matlab
run_all
```

Generated artifacts are written under `results/`. The generated model is written to `models/quarter_car.slx`.

## Test

```matlab
addpath("scripts")
results = runtests("tests");
assertSuccess(results)
```

## Repository layout

```text
matlab-automation-lab/
├── configs/
│   └── parameters.csv
├── scripts/
│   ├── build_quarter_car_model.m
│   ├── calculate_kpis.m
│   ├── evaluate_requirements.m
│   ├── generate_report.m
│   ├── load_parameters.m
│   ├── quarter_car_matrices.m
│   └── run_parameter_sweep.m
├── tests/
├── run_all.m
├── AGENTS.md
└── README.md
```

## KPIs

For each parameter set, v0.1 calculates:

- peak absolute sprung-mass acceleration `[m/s^2]`
- RMS sprung-mass acceleration `[m/s^2]`
- peak absolute suspension travel `[mm]`
- peak absolute tire deflection `[mm]`

PASS/FAIL is determined from the acceleration and suspension-travel limits in `configs/parameters.csv`.

## Next steps

- Simulink Test regression harness
- Model Advisor quality gate
- parallel parameter sweeps with `parsim`
- HTML/PDF reporting
- GitHub Actions / self-hosted MATLAB CI
