function [A, B, C, D] = quarter_car_matrices(ms, mu, ks, cs, kt)
%QUARTER_CAR_MATRICES Continuous state-space model for a 2-DOF quarter car.
%
% State vector:
%   x = [sprung position; sprung velocity; unsprung position; unsprung velocity]
%
% Input:
%   r = road displacement
%
% Outputs:
%   1. sprung-mass acceleration
%   2. suspension travel (sprung - unsprung)
%   3. tire deflection (unsprung - road)
%   4. sprung-mass displacement

arguments
    ms (1,1) double {mustBePositive, mustBeFinite}
    mu (1,1) double {mustBePositive, mustBeFinite}
    ks (1,1) double {mustBePositive, mustBeFinite}
    cs (1,1) double {mustBePositive, mustBeFinite}
    kt (1,1) double {mustBePositive, mustBeFinite}
end

A = [ ...
    0,          1,               0,           0; ...
   -ks/ms,     -cs/ms,           ks/ms,       cs/ms; ...
    0,          0,               0,           1; ...
    ks/mu,      cs/mu, -(ks + kt)/mu,        -cs/mu];

B = [0; 0; 0; kt/mu];

C = [ ...
   -ks/ms, -cs/ms,  ks/ms,  cs/ms; ...
    1,      0,     -1,      0; ...
    0,      0,      1,      0; ...
    1,      0,      0,      0];

D = [0; 0; -1; 0];
end
