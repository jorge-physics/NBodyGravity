function fid = writePositionDataToCSV(s,csv_filename)

% Example: positions is a 3xNTxN array, where:
% 1st dimension (3): X, Y, Z coordinates
% 2nd dimension (NT): Number of time points
% 3rd dimension (N): Number of spheres
sizs = size(s);
% Create a test array for demonstration (replace with your actual data)
NT = sizs(2);  % Number of time points
N = sizs(3);     % Number of spheres

% Initialize the positions variable with random data (for demonstration)
positions = s;

% Define sphere names and sizes (you can modify this as needed)
sphere_names = arrayfun(@(i) sprintf('Sphere%d', i), 1:N, 'UniformOutput', false);
sphere_sizes = rand(1, N);  % Random sizes (you can specify exact sizes)

% Open a file for writing the CSV

fid = fopen(csv_filename, 'w');

% Write the CSV header
fprintf(fid, 'Object Name,Frame,X,Y,Z,Size\n');

% Loop over each sphere and each time point to write the data
for sphere_idx = 1:N
    tit = 0;
    for time_idx = 1:20:NT
        tit = tit + 1;
        % Get the X, Y, Z coordinates for the current sphere at the current time point
        X = positions(1, time_idx, sphere_idx)/1e3;
        Y = positions(2, time_idx, sphere_idx)/1e3;
        Z = positions(3, time_idx, sphere_idx)/1e3;
        
        % Get the current frame (time_idx) and sphere name
        frame = tit;  % Assuming frame = time point index
        sphere_name = sphere_names{sphere_idx};
        sphere_size = sphere_sizes(sphere_idx);  % Use the predefined size
        
        % Write the row to the CSV file
        fprintf(fid, '%s,%d,%.6f,%.6f,%.6f,%.6f\n', sphere_name, frame, X, Y, Z, sphere_size);
    end
end

% Close the CSV file
fclose(fid);

sprintf('CSV file written: %s\n', csv_filename);

return
end