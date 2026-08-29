function config = load_parameters(configPath)
%LOAD_PARAMETERS Read and validate parameter-sweep configuration.

arguments
    configPath (1,1) string
end

if ~isfile(configPath)
    error("matlabAutomation:ConfigNotFound", ...
        "Configuration file not found: %s", configPath);
end

config = readtable(configPath, "TextType", "string");

required = [ ...
    "case_id", "sprung_mass_kg", "unsprung_mass_kg", ...
    "spring_npm", "damper_nspm", "tire_npm", ...
    "road_height_m", "road_step_time_s", "sim_stop_time_s", ...
    "max_body_accel_mps2", "max_suspension_travel_mm"];

missing = setdiff(required, string(config.Properties.VariableNames));
if ~isempty(missing)
    error("matlabAutomation:InvalidConfig", ...
        "Missing required columns: %s", strjoin(missing, ", "));
end

numericColumns = setdiff(required, "case_id");
for name = numericColumns
    values = config.(name);
    if ~isnumeric(values) || any(~isfinite(values)) || any(values <= 0)
        error("matlabAutomation:InvalidConfig", ...
            "Column %s must contain finite positive numeric values.", name);
    end
end

if numel(unique(config.case_id)) ~= height(config)
    error("matlabAutomation:InvalidConfig", ...
        "case_id values must be unique.");
end
end
