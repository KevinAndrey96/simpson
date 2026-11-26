function run_tests()
    % RUN_TESTS Runs every tests/test_*.m suite in MATLAB or GNU Octave.
    %
    % Each suite is a function that returns a cell array of handles to its
    % local test functions. A test fails when it throws; the runner reports
    % every failure and raises an error at the end so CI exits non-zero.

    here = fileparts(mfilename('fullpath'));
    addpath(here);
    addpath(fullfile(here, '..', 'src'));

    suites = dir(fullfile(here, 'test_*.m'));
    total = 0;
    failures = {};

    for s = 1:numel(suites)
        suite_name = suites(s).name(1:end - 2);
        cases = feval(suite_name);
        for c = 1:numel(cases)
            test_name = sprintf('%s/%s', suite_name, func2str(cases{c}));
            total = total + 1;
            try
                cases{c}();
                fprintf('  ok    %s\n', test_name);
            catch failure
                fprintf('  FAIL  %s\n        %s\n', test_name, failure.message);
                failures{end + 1} = test_name; %#ok<AGROW>
            end
        end
    end

    fprintf('\n%d tests, %d failures\n', total, numel(failures));
    if ~isempty(failures)
        error('tests:failed', '%d of %d tests failed', numel(failures), total);
    end
end
