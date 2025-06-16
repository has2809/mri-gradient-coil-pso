% Design of longitudinal gradient coil for MRI system using Particle Swarm Optimization (PSO).

%Constants
a = 0.4;        %Coil radius
L = 0.25;       %Region of interest
I = 25;         %Current
N_pairs = 8;    %Number of coil pairs
N_agents = 25;  % Number of agents for PSO algorithm
min = 0;
max = 0.5;      % Minimum and maximum value for the search space
dynamic_range = abs(max) + abs(min);
V_max = dynamic_range;     %Maximum value for velocities (step sizes)
delta_t = 1;
c1 = 2;
c2 = 2;
N_int_segs = 300;          %Number of integration segments used in Simpson's integral function
max_iter = 500;            
eps = 1e-8;
relative_error = 1;


Bz_desired = @(z) 0.001*z;
fit = @(Zi) integral(@(z) (Bz(z,a,Zi,I) - Bz_desired(z) )^2, -L, L, N_int_segs);  %Fitness Function

%Initilize data
Z = min + rand(N_agents, N_pairs) * dynamic_range;    
V = zeros(N_agents, N_pairs);         
pbest = Z; 
pbest_value = zeros(N_agents,1);
pbest_value(1) = fit(Z(1,:));
gbest = Z(1,:);
gbest_value = pbest_value(1);
for i=2:N_agents
    pbest_value(i) = fit(Z(i,:));
    if pbest_value(i) < gbest_value
        gbest = Z(i,:)
        gbest_value = pbest_value(i)
    end     
end

%Algorithm
iter = 0;
while iter < max_iter && abs(relative_error) > eps
    iter = iter+1
    W = 0.9 - (0.9-0.4)*iter/max_iter;    %Decreases linearly with increase in iterations
    for i=1:N_agents
        for n=1:N_pairs
            V(i,n) = W*V(i,n) + c1*rand(1)*( pbest(i,n) - Z(i,n) ) + c2*rand(1)*( gbest(n) - Z(i,n) );
            if V(i,n) > V_max
                V(i,n) = V_max;
            end
            Z(i,n) = Z(i,n) + V(i,n) * delta_t;
            if Z(i,n) > max      %Absorbing boundary condition
                Z(i,n) = max;
            elseif Z(i,n) < min
                Z(i,n) = min;
            end
        end
        f = fit(Z(i,:));
        if f < pbest_value(i)
            pbest(i,:) = Z(i,:);
            pbest_value(i) = f;
            if f < gbest_value
                relative_error = (f- gbest_value) / f;
                gbest = Z(i,:)
                gbest_value = f
            end
        end
    end
end

%Plotting the results
disp(gbest)
disp(gbest_value)
X_axis = linspace(-L,L,1000);
Y_axis = zeros(1000);
for i=1:1000
    Y_axis(i) = Bz(X_axis(i),a,gbest,I);
end
plot(X_axis,Y_axis)
hold on;
plot(X_axis,Bz_desired(X_axis))
legend('Model', 'Desired Output', 'Location', 'southeast')