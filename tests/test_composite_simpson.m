function tests = test_composite_simpson()
    tests = {@exact_for_cubic_polynomials, @matches_the_original_power_exercise, ...
             @converges_with_fourth_order, @reversed_limits_flip_the_sign, ...
             @empty_interval_is_zero, @accepts_non_vectorized_integrands, ...
             @rejects_odd_or_invalid_subintervals, @rejects_invalid_limits, ...
             @rejects_non_handles, @rejects_singular_integrands};
end

function exact_for_cubic_polynomials()
    f = @(x) 4 * x.^3 - 3 * x.^2 + 2 * x - 7;
    antiderivative = @(x) x.^4 - x.^3 + x.^2 - 7 * x;
    expected = antiderivative(3) - antiderivative(-2);
    assert_close(composite_simpson(f, -2, 3, 2), expected, 1e-12, 'n = 2');
    assert_close(composite_simpson(f, -2, 3, 10), expected, 1e-12, 'n = 10');
end

function matches_the_original_power_exercise()
    exact = 5^5.5 / 5.5;
    value = composite_simpson(@(x) x.^4.5, 0, 5, 200);
    assert_close(value, exact, 1e-6 * exact, 'x^4.5 on [0, 5]');
end

function converges_with_fourth_order()
    exact = 1 - cos(2);
    study = simpson_convergence(@sin, 0, 2, exact, [8, 16, 32, 64]);
    orders = [study(2:end).observed_order];
    if any(abs(orders - 4) > 0.05)
        error('tests:order', 'observed orders %s are not close to 4', mat2str(orders, 4));
    end
end

function reversed_limits_flip_the_sign()
    forward = composite_simpson(@exp, 0, 1, 20);
    backward = composite_simpson(@exp, 1, 0, 20);
    assert_close(backward, -forward, 1e-14, 'reversed interval');
end

function empty_interval_is_zero()
    assert_close(composite_simpson(@exp, 2, 2, 4), 0, 0, 'a == b');
end

function accepts_non_vectorized_integrands()
    scalar_only = @(x) max(x, 0)^2;
    assert_close(composite_simpson(scalar_only, 0, 3, 6), 9, 1e-12, 'x^2 on [0, 3]');
end

function rejects_odd_or_invalid_subintervals()
    for n = {3, 0, -2, 2.5, [2, 4], 'four'}
        assert_error_id(@() composite_simpson(@sin, 0, 1, n{1}), 'simpson:invalidSubintervals');
    end
end

function rejects_invalid_limits()
    assert_error_id(@() composite_simpson(@sin, 0, Inf, 4), 'simpson:invalidLimits');
    assert_error_id(@() composite_simpson(@sin, NaN, 1, 4), 'simpson:invalidLimits');
    assert_error_id(@() composite_simpson(@sin, [0, 1], 1, 4), 'simpson:invalidLimits');
end

function rejects_non_handles()
    assert_error_id(@() composite_simpson('sin', 0, 1, 4), 'simpson:invalidIntegrand');
end

function rejects_singular_integrands()
    assert_error_id(@() composite_simpson(@(x) 1 ./ x, 0, 1, 4), 'simpson:nonFiniteIntegrand');
end
