clc
clear

n=10; % number of job
m=5; % number of machine


p=randi([1 100],n,m); % processing time

for i=1:m
s{i}=randi([0 9],[n,n]); % sequence dependent set up time
end


d=randi([110 500],n,1);  % due date of each job


save data


