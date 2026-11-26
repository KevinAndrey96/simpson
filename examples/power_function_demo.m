% POWER_FUNCTION_DEMO Reproduces the original 2020 exercise: integrate
% f(x) = x^4.5 over [0, 5], compare with the exact value and show how the
% error falls as the number of subintervals doubles.
%
% Run from the repository root:
%   octave-cli examples/power_function_demo.m
%   matlab -batch "run('examples/power_function_demo.m')"

addpath(fullfile(fileparts(mfilename('fullpath')), '..', 'src'));

f = @(x) x.^4.5;
a = 0;
b = 5;
exact = (b^5.5 - a^5.5) / 5.5;

fprintf('Integral of x^4.5 on [%g, %g], exact value %.15f\n\n', a, b, exact);
fprintf('%8s  %22s  %12s  %12s  %7s\n', 'n', 'Simpson 1/3', 'abs error', 'rel error', 'order');

study = simpson_convergence(f, a, b, exact, 2.^(1:10));
for row = study
    fprintf('%8d  %22.15f  %12.3e  %12.3e  %7.3f\n', row.n, row.approximation, ...
            row.absolute_error, row.relative_error, row.observed_order);
end

[value, evaluations] = adaptive_simpson(f, a, b, 1e-10);
fprintf('\nAdaptive Simpson: %.15f with %d evaluations, error %.3e\n', ...
        value, evaluations, abs(exact - value));
