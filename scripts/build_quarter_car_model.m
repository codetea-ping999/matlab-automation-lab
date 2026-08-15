function build_quarter_car_model(modelPath)
%BUILD_QUARTER_CAR_MODEL Build a reproducible Simulink Quarter-car model.

arguments
    modelPath (1,1) string
end

[modelDir, modelName, ext] = fileparts(modelPath);
if ext ~= ".slx"
    error("matlabAutomation:InvalidModelPath", ...
        "modelPath must end with .slx");
end

if ~isfolder(modelDir)
    mkdir(modelDir);
end

if bdIsLoaded(modelName)
    close_system(modelName, 0);
end

new_system(modelName);
cleanup = onCleanup(@() close_if_loaded(modelName));

set_param(modelName, ...
    "Solver", "ode45", ...
    "ReturnWorkspaceOutputs", "on");

add_block("simulink/Sources/Step", modelName + "/Road Step", ...
    "Time", "road_step_time", ...
    "Before", "0", ...
    "After", "road_height", ...
    "Position", [40 85 80 115]);

add_block("simulink/Continuous/State-Space", modelName + "/Quarter Car Plant", ...
    "A", "A_qc", ...
    "B", "B_qc", ...
    "C", "C_qc", ...
    "D", "D_qc", ...
    "Position", [150 65 285 135]);

add_block("simulink/Signal Routing/Demux", modelName + "/Outputs", ...
    "Outputs", "4", ...
    "Position", [345 55 350 155]);

signalNames = ["body_accel_ts", "suspension_travel_ts", ...
    "tire_deflection_ts", "body_displacement_ts"];
blockNames = ["Body Acceleration", "Suspension Travel", ...
    "Tire Deflection", "Body Displacement"];

for i = 1:numel(signalNames)
    y = 20 + (i - 1) * 55;
    add_block("simulink/Sinks/To Workspace", modelName + "/" + blockNames(i), ...
        "VariableName", signalNames(i), ...
        "SaveFormat", "Timeseries", ...
        "Position", [430 y 565 y+30]);
end

add_line(modelName, "Road Step/1", "Quarter Car Plant/1", "autorouting", "on");
add_line(modelName, "Quarter Car Plant/1", "Outputs/1", "autorouting", "on");
for i = 1:4
    add_line(modelName, "Outputs/" + i, blockNames(i) + "/1", "autorouting", "on");
end

save_system(modelName, modelPath);
end

function close_if_loaded(modelName)
if bdIsLoaded(modelName)
    close_system(modelName, 0);
end
end
