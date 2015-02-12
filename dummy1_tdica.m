% Demo of Time Domain ICA with Natural Gradient Algorithm
% with dummy signal (sin).

close all; clear all;  clc;

t=0:pi/100:10*pi;           %time series (sumbu-x)
s1=sin(0.2*t);              %sinyal dari sumber 1
s2=sin(2*t);                %sinyal dari sumber 2

figure(1)
subplot(211); plot(s1);
subplot(212); plot(s2);

x1=0.1*s1+0.9*s2;           %sinyal yang diterima mic1/left ear
x2=-0.3*s2+0.9*s1;           %sinyal yang diterima mic2/right ear

mic_1=x1;   %Reading file from microphone #1.
mic_2=x2;   %Reading file from microphone #2.

% Plot sinyal input TDICA
figure(2)
subplot(211); plot(mic_1);
subplot(212); plot(mic_2);

mix=[mic_1;mic_2];             %mencampur file suara

%P=number of data points, NxP matrix
[N,P]=size(mix);               %P=sampled time=50000;N=number of input=3

% for manualy mixing sources
% permute=randperm(N);           %generate a permutation vector
% x=mix(permute,:);              %time-scrambled inputs for stationarity

x=mix;
%% pre processing (whitening/sphering)
mx=mean(mix');                  %menghitung rata2
c=cov(mix');                    %menghitung kovarian/simpangan baku 
x=x-mx'*ones(1,P);              %campuran-rata2
wz=2*inv(sqrtm(c));             %untuk mendapatkan matrix dekorelasi
x=wz*x;                         %dekorelasi campuran shg cov(x')=4*eye(N)

%inisiasi matriks pemisah
w=eye(N);                       %matriks identitas square dg dimensi N  
M=size(w,2);                    %mencari dimensi matriks w          
sweep=0; oldw=w; olddelta=ones(1,N*N);
Id=eye(M);

% proses pemisahan
L=0.0001; B=30; for I=1:100, sep; end;          %ITERASI TDICA

% Pemisahan sinyal suara
uu=w^-1/wz*mix;         % make unmixed sources
uu11=uu(1,:);
uu12=uu(2,:);

% Plot sinyal estimasi TDICA/input FDICA
figure(3);
subplot(211); plot(uu11);
subplot(212); plot(uu12);
