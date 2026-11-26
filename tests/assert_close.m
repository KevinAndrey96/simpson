function assert_close(actual, expected, tolerance, label)
    % ASSERT_CLOSE Fails when |actual - expected| exceeds tolerance.

    if nargin < 4
        label = 'value';
    end
    difference = abs(actual - expected);
    if ~(difference <= tolerance)
        error('tests:notClose', '%s: expected %.17g, got %.17g (difference %.3e > %.3e)', ...
              label, expected, actual, difference, tolerance);
    end
end
