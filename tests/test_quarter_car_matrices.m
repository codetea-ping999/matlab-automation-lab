function tests = test_quarter_car_matrices
tests = functiontests(localfunctions);
end

function setupOnce(~)
rootDir = fileparts(fileparts(mfilename("fullpath")));
addpath(fullfile(rootDir, "scripts"));
end

function testDimensionsAndFiniteValues(testCase)
[A, B, C, D] = quarter_car_matrices(300, 40, 18000, 1500, 180000);

verifySize(testCase, A, [4 4]);
verifySize(testCase, B, [4 1]);
verifySize(testCase, C, [4 4]);
verifySize(testCase, D, [4 1]);
verifyTrue(testCase, all(isfinite([A(:); B(:); C(:); D(:)])));
end

function testRoadInputActsOnUnsprungMass(testCase)
[~, B, ~, D] = quarter_car_matrices(300, 40, 18000, 1500, 180000);
verifyEqual(testCase, B(4), 180000/40, "AbsTol", 1e-12);
verifyEqual(testCase, D(3), -1);
end
