% demoed ICA separation with dummy mixed signal 
% (mixed with random matrices)

clear all; clc;

t=0:pi/100:10*pi;

s1=sin(2*t);
s2=sign(sin(3*t));

% x1=0.2*s1+0.7*s2;
% x2=0.6*s2+0.3*s1;

figure(1);
subplot(211); plot(s1);
subplot(212); plot(s2);

sources=[s1;s2];

[N,P]=size(sources);                 % P=17408, N=2, for example
permute=randperm(P);                 % generate a permutation vector
s=sources(:,permute);                % time-scrambled inputs for stationarity

a=rand(N);                           % mixing matrix, or:  a=rand(N);
x=a*s;                               % mix input signals (permuted)
mixes=a*sources;                     % make mixed sources (not permuted)

%**** if you are loading already-mixed sources:

%**** sphere the data
mx=mean(mixes'); c=cov(mixes');
x=x-mx'*ones(1,P);                   % subtract means from mixes
wz=2*inv(sqrtm(c));                  % get decorrelating matrix
x=wz*x;                              % decorrelate mixes so cov(x')=4*eye(N);

%**** 
%w=[1 1; 1 2];                          % init. unmixing matrix, or w=rand(M,N);
w=eye(N);                               % init. unmixing matrix, or w=rand(M,N);
M=size(w,2);                            % M=N usually
sweep=0; oldw=w; olddelta=ones(1,N*N);
Id=eye(M);                              % for artifial data, use this

%************* this learns: "help sep" explains all 

% L=0.01; B=30; sep    % should converge on 1 pass for 2->2 net
% L=0.001; B=30; sep   % but annealing will improve soln even more 
% L=0.0001; B=30; sep  % and so on

% for multiple sweeps:
L=0.001; B=30; for I=1:100, sep; end;
%***************************************

mixes=a*sources;         % make mixed sources
% sound(mixes(1,:))      % play the first one (if it is audio)

uu=w*wz*mixes;              % make unmixed sources
% sound(uu(1,:))            % play the first one (if it is audio)

figure(2)
subplot(211); plot(uu(1,:))          % plot the first one (if it is another signal)
subplot(212); plot(uu(2,:))          % 