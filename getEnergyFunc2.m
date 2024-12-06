function [E, rdens] = getEnergyFunc2(t, s, m, N, G)
    % Inputs:
    % t     - Time (unused in the function)
    % s     - 3D array (6 x M x N), state of particles (positions and velocities)
    % m     - Vector (1 x N), masses of particles
    % N     - Number of particles
    % G     - Gravitational constant
    %
    % Outputs:
    % E     - Total energy of the system (kinetic + potential)
    % rdens - Relative density-like measure based on inverse distances

    % Initialize total kinetic energy
    T = 0; % Total kinetic energy
    for i = 1:N
        % Compute kinetic energy for each particle:
        % KE = 0.5 * mass * velocity^2
        % Velocity components are in rows 4:6 of s for particle i
        T = T + 0.5 * m(i) * sum(s(4:6,:,i).^2, 1); % Sum over all time steps
    end

    % Generate all pairwise combinations of particles for gravitational interaction
    cvec = nchoosek(1:N, 2); % All pairs of particles
    ds = size(cvec); % Dimensions of the pairs array

    % Initialize total potential energy and relative density measure
    V = 0; % Total potential energy
    rdens = 1; % Initialize relative density product

    for i = 1:ds(1) % Loop over all particle pairs
        % Compute relative position vector between the two particles
        temp = s(1:3,:,cvec(i,1)) - s(1:3,:,cvec(i,2));
        % Compute distance between the two particles
        r = sqrt(sum(temp.^2, 1)); % Distance formula in 3D

        % Add gravitational potential energy for this pair
        V = V - G * m(cvec(i,1)) * m(cvec(i,2)) ./ r;

        % Update density-like measure
        % Avoid division by zero using eps(r)
        rdens = rdens ./ (r + eps(r));
    end

    % Compute total energy
    E = T + V; % Total energy is kinetic + potential
end
