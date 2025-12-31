function params = estimate_2RC_parameters(time, voltage, current)

    dt = mean(diff(time));

    % Initial guess: [R0 R1 C1 R2 C2]
    x0 = [0.05, 0.01, 2000, 0.02, 5000];

    lb = [0, 0, 100, 0, 100];
    ub = [0.5, 1, 1e5, 1, 1e5];

    obj = @(x) voltage_error(x, time, voltage, current, dt);
    options = optimoptions('lsqnonlin','Display','off');

    x = lsqnonlin(obj, x0, lb, ub, options);

    params.R0 = x(1);
    params.R1 = x(2);
    params.C1 = x(3);
    params.R2 = x(4);
    params.C2 = x(5);
end


function err = voltage_error(x, time, Vmeas, I, dt)

    R0 = x(1); R1 = x(2); C1 = x(3);
    R2 = x(4); C2 = x(5);

    V1 = 0; V2 = 0;
    Vest = zeros(size(Vmeas));

    for k = 2:length(time)
        V1 = V1 + dt * (-V1/(R1*C1) + I(k)/C1);
        V2 = V2 + dt * (-V2/(R2*C2) + I(k)/C2);
        Vest(k) = Vmeas(1) - I(k)*R0 - V1 - V2;
    end

    err = Vest - Vmeas;
end
