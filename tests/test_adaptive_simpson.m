function tests = test_adaptive_simpson()
    tests = {@meets_the_requested_tolerance, @spends_fewer_evaluations_on_easy_integrands, ...
             @handles_sharp_peaks, @uses_default_tolerance, @rejects_invalid_input};
end

function meets_the_requested_tolerance()
    exact = exp(1) - 1;
    for tolerance = [1e-4, 1e-8, 1e-12]
        value = adaptive_simpson(@exp, 0, 1, tolerance);
        assert_close(value, exact, tolerance, sprintf('tolerance %g', tolerance));
    end
end

function spends_fewer_evaluations_on_easy_integrands()
    [~, smooth] = adaptive_simpson(@(x) x.^2, 0, 1, 1e-10);
    [~, wiggly] = adaptive_simpson(@(x) sin(20 * x), 0, 1, 1e-10);
    if smooth ~= 5
        error('tests:evaluations', 'a quadratic needs a single refinement, used %d calls', smooth);
    end
    if wiggly <= smooth
        error('tests:evaluations', 'oscillating integrand should need more calls than %d', smooth);
    end
end

function handles_sharp_peaks()
    peak = @(x) 1 ./ (1e-4 + (x - 0.3).^2);
    exact = (atan(0.7 / 1e-2) + atan(0.3 / 1e-2)) / 1e-2;
    assert_close(adaptive_simpson(peak, 0, 1, 1e-8), exact, 1e-6, 'Lorentzian peak');
end

function uses_default_tolerance()
    assert_close(adaptive_simpson(@cos, 0, pi / 2), 1, 1e-10, 'default tolerance');
end

function rejects_invalid_input()
    assert_error_id(@() adaptive_simpson(@sin, 0, 1, 0), 'simpson:invalidTolerance');
    assert_error_id(@() adaptive_simpson(@sin, 0, Inf), 'simpson:invalidLimits');
    assert_error_id(@() adaptive_simpson(42, 0, 1), 'simpson:invalidIntegrand');
end
