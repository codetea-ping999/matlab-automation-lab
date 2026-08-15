function evaluation = evaluate_requirements(kpi, maxBodyAccel, maxSuspensionTravel)
%EVALUATE_REQUIREMENTS Evaluate v0.1 requirements for one simulation case.

arguments
    kpi (1,1) struct
    maxBodyAccel (1,1) double {mustBePositive, mustBeFinite}
    maxSuspensionTravel (1,1) double {mustBePositive, mustBeFinite}
end

accelPass = kpi.peak_body_accel_mps2 <= maxBodyAccel;
travelPass = kpi.peak_suspension_travel_mm <= maxSuspensionTravel;

evaluation.pass = accelPass && travelPass;
evaluation.accel_pass = accelPass;
evaluation.travel_pass = travelPass;

reasons = strings(0,1);
if ~accelPass
    reasons(end+1) = sprintf("body acceleration %.3f > %.3f m/s^2", ...
        kpi.peak_body_accel_mps2, maxBodyAccel);
end
if ~travelPass
    reasons(end+1) = sprintf("suspension travel %.3f > %.3f mm", ...
        kpi.peak_suspension_travel_mm, maxSuspensionTravel);
end

if isempty(reasons)
    evaluation.reason = "PASS";
else
    evaluation.reason = strjoin(reasons, "; ");
end
end
