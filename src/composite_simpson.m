function integral = composite_simpson(f, a, b, n)
    % COMPOSITE_SIMPSON Approximates the integral of f over [a, b] with the
    % composite Simpson 1/3 rule on n equal subintervals.
    %
    %   integral = composite_simpson(f, a, b, n)
    %
    %   f  function handle of one variable; it is evaluated element-wise
    %      when it is vectorized and point by point otherwise
    %   a  lower limit (finite real scalar)
    %   b  upper limit (finite real scalar, may be smaller than a)
    %   n  number of subintervals (positive even integer)
    %
    %   The rule is exact for polynomials up to degree three and its global
    %   truncation error is -(b - a) h^4 f''''(xi) / 180 with h = (b - a) / n.

    validate_integrand(f);
    validate_limits(a, b);
    if ~isnumeric(n) || ~isscalar(n) || ~isreal(n) || n < 2 || mod(n, 2) ~= 0
        error('simpson:invalidSubintervals', 'n must be a positive even integer');
    end

    h = (b - a) / n;
    x = a + (0:n) * h;
    weights = 2 * ones(1, n + 1);
    weights(2:2:n) = 4;
    weights([1, n + 1]) = 1;

    integral = h / 3 * sum(weights .* evaluate(f, x));
end

function validate_integrand(f)
    if ~isa(f, 'function_handle')
        error('simpson:invalidIntegrand', 'f must be a function handle');
    end
end

function validate_limits(a, b)
    limits = [a, b];
    if ~isnumeric(limits) || numel(limits) ~= 2 || ~isreal(limits) || any(~isfinite(limits))
        error('simpson:invalidLimits', 'a and b must be finite real scalars');
    end
end

function y = evaluate(f, x)
    try
        y = f(x);
    catch
        y = [];
    end
    if ~isequal(size(y), size(x))
        y = arrayfun(f, x);
    end
    if any(~isfinite(y))
        error('simpson:nonFiniteIntegrand', ...
              'f is not finite at every node, check for singularities in [a, b]');
    end
end
