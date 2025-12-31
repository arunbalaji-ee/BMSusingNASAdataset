function idx = select_valid_window(time)

    N = length(time);

    idx_start = round(0.05 * N);   % remove first 5%
    idx_end   = round(0.90 * N);   % remove last 10%

    idx = false(N,1);
    idx(idx_start:idx_end) = true;

end
