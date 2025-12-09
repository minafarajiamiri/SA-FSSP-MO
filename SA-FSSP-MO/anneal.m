clc;
clear;
close all;
%% parametere of Simulated Annealing

nc = 10;% Number of cycles
nt = 5;% Number of trials per cycle
na = 0.0;% Number of accepted solutions
p1 = 0.7;% Probability of accepting worse solution at the start
p10 = 0.001;% Probability of accepting worse solution at the end
t1 = -1.0/log(p1);% Initial temperature
t10 = -1.0/log(p10);% Final temperature
frac = (t10/t1)^(1.0/(nc-1.0));% Fractional reduction every cycle
%% data of problem

a=load('data.mat');
nm=a.m;% number of machine
nj=a.n;% number of jobs
p=a.p;% processing time
d=a.d;% due date of each job
% setup time
for i=1:nm
s{i}=a.s{i};
end
s=cell(nm);
% weight of each objective
a1=0.2;% tardiness
a2=0.1;% makespan
a3=0.4;% earliness
a4=0.3;% number of tardy jobs
%% Initialization

x = zeros(nc,1);
fs = zeros(nc,1);
seq = zeros(nj,1);
i = zeros(nj,nm);
c = zeros(nj,nm);
x_start =randperm(nj);% initial solution
xc = x_start;
na = na + 1.0;% number of accepted answers
fc = fitness(xc,nm,nj,p,s,d,a1,a2,a3,a4);% Current best results so far
t = t1;% Current temperature
DeltaE_avg = 0.0;% DeltaE Average
%% main loop

for i=1:nc
    disp(['Cycle: ',num2str(i),' with Temperature: ',num2str(t),' xc: ' , num2str(xc)]);
    for j=1:nt
        xj = arr_change(xc) ; % Generate new trial points
        disp(['trial: ',num2str(j),' with trial point: ',num2str(xj)])
        DeltaE = abs(fitness(xj,nm,nj,p,s,d,a1,a2,a3,a4)-fc);
        if (fitness(xj,nm,nj,p,s,d,a1,a2,a3,a4)>fc)
            % Initialize DeltaE_avg if a worse solution was found 
            if (i==1 && j==1)%   on the first iteration
                DeltaE_avg = DeltaE;
            end
            % objective function is worse
            
            pp = exp(-DeltaE/(DeltaE_avg * t));% generate probability of acceptance
           % determine whether to accept worse point
            if (rand()<pp)
                accept = true;% accept the worse solution
            else
                accept = false;% don't accept the worse solution
            end
        else
            accept = true;% objective function is lower, automatically accept
        end
        if (accept==true)
            xc = xj;% update currently accepted solution
            fc =fitness(xj,nm,nj,p,s,d,a1,a2,a3,a4);
            na = na + 1.0;% increase number of accepted solutions
            DeltaE_avg = (DeltaE_avg * (na-1.0) +  DeltaE) / na;% update DeltaE_avg
        end
    end
    % Record the best x values at the end of every cycle
    xi = xc;
    fs(i) = fc;
    t = frac * t;% Lower the temperature for next cycle
end
%% results
disp(['Best solution: ',num2str(xi)])
disp(['Best objective: ',num2str(fs(i))])

fig=figure(1);
plot(xi,'b.-');
xlabel('cycles');
ylabel('best solution');
grid on;
fig=figure(2);
plot(fs,'r.-');
xlabel('cycles');
ylabel('best objective');
grid on;