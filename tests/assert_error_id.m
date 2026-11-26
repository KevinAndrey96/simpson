function assert_error_id(action, identifier)
    % ASSERT_ERROR_ID Fails unless action() throws an error with identifier.

    try
        action();
    catch failure
        if ~strcmp(failure.identifier, identifier)
            error('tests:wrongError', 'expected error %s, got %s: %s', ...
                  identifier, failure.identifier, failure.message);
        end

        return
    end
    error('tests:noError', 'expected error %s, but nothing was thrown', identifier);
end
