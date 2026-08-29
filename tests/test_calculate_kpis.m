function tests = test_calculate_kpis
tests = functiontests(localfunctions);
end

function setupOnce(~)
rootDir = fileparts(fileparts(mfilename("fullpath")));
addpath(fullfile(rootDir, "scripts"));
end

function testKnownSignals(testCase)
t = (0:0.1:0.3)';
bodyAccel = timeseries([0; 1; -2; 1], t);
suspension = timeseries([0; 0.01; -0.02; 0.01], t);
tire = timeseries([0; 0.005; -0.01; 0.005], t);

kpi = calculate_kpis(bodyAccel, suspension, tire);

verifyEqual(testCase, kpi.peak_body_accel_mps2, 2, "AbsTol", 1e-12);
verifyEqual(testCase, kpi.rms_body_accel_mps2, sqrt(1.5), "AbsTol", 1e-12);
verifyEqual(testCase, kpi.peak_suspension_travel_mm, 20, "AbsTol", 1e-12);
verifyEqual(testCase, kpi.peak_tire_deflection_mm, 10, "AbsTol", 1e-12);
end
