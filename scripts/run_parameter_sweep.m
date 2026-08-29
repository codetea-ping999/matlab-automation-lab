function results = run_parameter_sweep(config, modelPath)
%RUN_PARAMETER_SWEEP Run all configured Quarter-car simulations sequentially.

arguments
    config table
    modelPath (1,1) string
end

[~, modelName] = fileparts(modelPath);
load_system(modelPath);
cleanup = onCleanup(@() close_system(modelName, 0));

records = repmat(struct(), height(config), 1);

for i = 1:height(config)
    row = config(i,:);

    [A_qc, B_qc, C_qc, D_qc] = quarter_car_matrices( ...
        row.sprung_mass_kg, row.unsprung_mass_kg, ...
        row.spring_npm, row.damper_nspm, row.tire_npm);

    simInput = Simulink.SimulationInput(modelName);
    simInput = simInput.setVariable("A_qc", A_qc);
    simInput = simInput.setVariable("B_qc", B_qc);
    simInput = simInput.setVariable("C_qc", C_qc);
    simInput = simInput.setVariable("D_qc", D_qc);
    simInput = simInput.setVariable("road_height", row.road_height_m);
    simInput = simInput.setVariable("road_step_time", row.road_step_time_s);
    simInput = simInput.setModelParameter( ...
        "StopTime", num2str(row.sim_stop_time_s), ...
        "ReturnWorkspaceOutputs", "on");

    simOut = sim(simInput);

    kpi = calculate_kpis( ...
        simOut.get("body_accel_ts"), ...
        simOut.get("suspension_travel_ts"), ...
        simOut.get("tire_deflection_ts"));

    evaluation = evaluate_requirements( ...
        kpi, row.max_body_accel_mps2, row.max_suspension_travel_mm);

    records(i).case_id = string(row.case_id);
    records(i).spring_npm = row.spring_npm;
    records(i).damper_nspm = row.damper_nspm;
    records(i).peak_body_accel_mps2 = kpi.peak_body_accel_mps2;
    records(i).rms_body_accel_mps2 = kpi.rms_body_accel_mps2;
    records(i).peak_suspension_travel_mm = kpi.peak_suspension_travel_mm;
    records(i).peak_tire_deflection_mm = kpi.peak_tire_deflection_mm;
    records(i).pass = evaluation.pass;
    records(i).reason = evaluation.reason;
    records(i).score = ...
        kpi.peak_body_accel_mps2 / row.max_body_accel_mps2 + ...
        kpi.peak_suspension_travel_mm / row.max_suspension_travel_mm;
end

results = struct2table(records);
results = sortrows(results, "score", "ascend");
end
