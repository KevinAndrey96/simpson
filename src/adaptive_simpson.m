function [integral, evaluations] = adaptive_simpson(f, a, b, tolerance, max_depth)
    % ADAPTIVE_SIMPSON Integrates f over [a, b] refining only where needed.
    %
    %   [integral, evaluations] = adaptive_simpson(f, a, b, tolerance, max_depth)
    %
    %   Each interval is split in two halves until the difference between the
    %   coarse and the refined Simpson estimates is below 15 * tolerance, and
    %   the refined estimate gets the Richardson correction (S2 - S1) / 15.
    %   The tolerance is shared between halves, so the final error estimate
    %   stays below the requested one for smooth integrands.
    %
    %   tolerance  absolute error target (positive scalar, default 1e-10)
    %   max_depth  maximum number of bisections (default 50)
    %
    %   evaluations is the number of times f was called.

    if nargin < 4
        tolerance = 1e-10;
    end
    if nargin < 5
        max_depth = 50;
    end
    if ~isa(f, 'function_handle')
        error('simpson:invalidIntegrand', 'f must be a function handle');
    end
    limits = [a, b];
    if ~isnumeric(limits) || numel(limits) ~= 2 || ~isreal(limits) || any(~isfinite(limits))
        error('simpson:invalidLimits', 'a and b must be finite real scalars');
    end
    if ~isnumeric(tolerance) || ~isscalar(tolerance) || ~(tolerance > 0)
        error('simpson:invalidTolerance', 'tolerance must be a positive scalar');
    end

    m = (a + b) / 2;
    fa = f(a);
    fm = f(m);
    fb = f(b);
    whole = simpson_panel(a, b, fa, fm, fb);
    [integral, calls] = refine(f, a, b, fa, fm, fb, whole, tolerance, max_depth);
    evaluations = 3 + calls;
end

function [integral, calls] = refine(f, a, b, fa, fm, fb, whole, tolerance, depth)
    m = (a + b) / 2;
    left_mid = (a + m) / 2;
    right_mid = (m + b) / 2;
    flm = f(left_mid);
    frm = f(right_mid);
    calls = 2;

    left = simpson_panel(a, m, fa, flm, fm);
    right = simpson_panel(m, b, fm, frm, fb);
    delta = left + right - whole;

    if depth <= 0 || abs(delta) <= 15 * tolerance
        integral = left + right + delta / 15;

        return
    end

    [left_integral, left_calls] = refine(f, a, m, fa, flm, fm, left, tolerance / 2, depth - 1);
    [right_integral, right_calls] = refine(f, m, b, fm, frm, fb, right, tolerance / 2, depth - 1);
    integral = left_integral + right_integral;
    calls = calls + left_calls + right_calls;
end

function value = simpson_panel(a, b, fa, fm, fb)
    value = (b - a) / 6 * (fa + 4 * fm + fb);
end
