function data = load_battery_csv(csvFile)

    T = readtable(csvFile);

    data.time = T.Time;
    data.current = abs(T.Current_measured);   % discharge positive
    data.voltage = T.Voltage_measured;
    data.temperature = T.Temperature_measured;

end
