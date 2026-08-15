function kpi = calculate_kpis(bodyAccel, suspensionTravel, tireDeflection)
%CALCULATE_KPIS Calculate v0.1 ride and travel KPIs from timeseries.

arguments
    bodyAccel (1,1) timeseries
    suspensionTravel (1,1) timeseries
    tireDeflection (1,1) timeseries
end

accel = double(bodyAccel.Data(:));
suspension = double(suspensionTravel.Data(:));
tire = double(tireDeflection.Data(:));

if any(~isfinite(accel)) || any(~isfinite(suspension)) || any(~isfinite(tire))
    error("matlabAutomation:InvalidSimulationOutput", ...
        "Simulation output contains non-finite values.");
end

kpi.peak_body_accel_mps2 = max(abs(accel));
kpi.rms_body_accel_mps2 = sqrt(mean(accel.^2));
kpi.peak_suspension_travel_mm = 1000 * max(abs(suspension));
kpi.peak_tire_deflection_mm = 1000 * max(abs(tire));
end
