%% MATLAB Automation Lab - v0.1
% Builds the model, runs the parameter sweep, evaluates KPIs, and writes a report.

rootDir = fileparts(mfilename("fullpath"));
addpath(fullfile(rootDir, "scripts"));

modelDir = fullfile(rootDir, "models");
if ~isfolder(modelDir)
    mkdir(modelDir);
end

modelPath = fullfile(modelDir, "quarter_car.slx");
configPath = fullfile(rootDir, "configs", "parameters.csv");

fprintf("[1/4] Building Quarter-car model...\n");
build_quarter_car_model(modelPath);

fprintf("[2/4] Loading parameter sets...\n");
config = load_parameters(configPath);

fprintf("[3/4] Running %d simulations...\n", height(config));
results = run_parameter_sweep(config, modelPath);

fprintf("[4/4] Writing report...\n");
generate_report(results, rootDir);

disp(results);
fprintf("Done. Results are under: %s\n", fullfile(rootDir, "results"));
