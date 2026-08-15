function generate_report(results, rootDir)
%GENERATE_REPORT Write machine-readable CSV and human-readable Markdown.

arguments
    results table
    rootDir (1,1) string
end

resultsDir = fullfile(rootDir, "results");
if ~isfolder(resultsDir)
    mkdir(resultsDir);
end

writetable(results, fullfile(resultsDir, "results.csv"));

reportPath = fullfile(resultsDir, "report.md");
fid = fopen(reportPath, "w");
if fid < 0
    error("matlabAutomation:ReportWriteFailed", ...
        "Could not open report for writing: %s", reportPath);
end
cleanup = onCleanup(@() fclose(fid));

fprintf(fid, "# Quarter-car Parameter Sweep Report\n\n");
fprintf(fid, "Generated: %s\n\n", string(datetime("now")));
fprintf(fid, "Cases: %d  \n", height(results));
fprintf(fid, "PASS: %d  \n", nnz(results.pass));
fprintf(fid, "FAIL: %d\n\n", nnz(~results.pass));

fprintf(fid, "| Rank | Case | k [N/m] | c [N s/m] | Peak accel [m/s^2] | RMS accel [m/s^2] | Susp. travel [mm] | Tire defl. [mm] | Result | Score |\n");
fprintf(fid, "|---:|---|---:|---:|---:|---:|---:|---:|---|---:|\n");

for i = 1:height(results)
    status = "FAIL";
    if results.pass(i)
        status = "PASS";
    end

    fprintf(fid, "| %d | %s | %.0f | %.0f | %.3f | %.3f | %.3f | %.3f | %s | %.3f |\n", ...
        i, results.case_id(i), results.spring_npm(i), results.damper_nspm(i), ...
        results.peak_body_accel_mps2(i), results.rms_body_accel_mps2(i), ...
        results.peak_suspension_travel_mm(i), results.peak_tire_deflection_mm(i), ...
        status, results.score(i));
end

fprintf(fid, "\n## Best case\n\n");
fprintf(fid, "Lowest normalized score: **%s** (%.3f).\n", ...
    results.case_id(1), results.score(1));

failed = results(~results.pass, :);
if ~isempty(failed)
    fprintf(fid, "\n## Failed requirements\n\n");
    for i = 1:height(failed)
        fprintf(fid, "- **%s**: %s\n", failed.case_id(i), failed.reason(i));
    end
end
end
