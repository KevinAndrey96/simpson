function study = simpson_convergence(f, a, b, exact, subintervals)
    % SIMPSON_CONVERGENCE Measures how the composite Simpson error shrinks.
    %
    %   study = simpson_convergence(f, a, b, exact, subintervals)
    %
    %   Returns a struct with one row per entry of subintervals:
    %     n               subintervals used
    %     approximation   composite Simpson estimate
    %     absolute_error  |exact - approximation|
    %     relative_error  absolute_error / |exact| (NaN when exact is zero)
    %     observed_order  log2 of the error ratio between consecutive rows;
    %                     close to 4 for smooth integrands when n doubles

    if nargin < 5
        subintervals = 2.^(1:10);
    end

    count = numel(subintervals);
    study = struct('n', num2cell(subintervals(:)'), 'approximation', 0, ...
                   'absolute_error', 0, 'relative_error', 0, 'observed_order', NaN);

    for k = 1:count
        value = composite_simpson(f, a, b, subintervals(k));
        error_value = abs(exact - value);
        study(k).approximation = value;
        study(k).absolute_error = error_value;
        if exact == 0
            study(k).relative_error = NaN;
        else
            study(k).relative_error = error_value / abs(exact);
        end
        if k > 1 && error_value > 0 && study(k - 1).absolute_error > 0
            ratio = study(k - 1).absolute_error / error_value;
            study(k).observed_order = log(ratio) / log(subintervals(k) / subintervals(k - 1));
        end
    end
end
