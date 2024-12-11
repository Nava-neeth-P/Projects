clc;
clear all;
v = 340; %Speed of sound in air
nDim = 3; %Number of dimensions of space
nSensors = 4; %Number of sensors

%creating the source 

Fs=44100;
t=1:1/Fs:3;
s=sin(2*pi*t*2000)+cos(2*pi*t*500); %sound source 


disp('Sound Source-Cordinates:');
x=input('X:');
y=input('Y:');
z=input('Z:');


disp('Mic 1-Cordinates:');
x1=.1;
y1=.1;
z1=1;

disp('Mic 2-Cordinates:');
x2=-.1;
y2=.1;
z2=0;

disp('Mic 3-Cordinates:');
x3=-.1;
y3=-.1;
z3=1;

disp('Mic 4-Cordinates:');
x4=.1;
y4=-.1;
z4=0;

%distance from sound source to microphones 
ds1=sqrt((x1-x)^2+(y1-y)^2)+((z1-z)^2);
ds2=sqrt((x2-x)^2+(y2-y)^2)+((z2-z)^2);
ds3=sqrt((x3-x)^2+(y3-y)^2)+((z3-z)^2);
ds4=sqrt((x4-x)^2+(y4-y)^2)+((z4-z)^2);


%Time Taken to reach sound source to microphones
ts1=ds1/v;
ts2=ds2/v;
ts3=ds3/v;
ts4=ds4/v;

%applying the simulated delays to the signals at each microphones
s1=[ zeros(1,floor(ts1*Fs)) s];
s2=[ zeros(1,floor(ts2*Fs)) s];
s3=[ zeros(1,floor(ts3*Fs)) s];
s4=[ zeros(1,floor(ts4*Fs)) s];

maxlen=max(length(s1),length(s2));
maxlen=max(maxlen,length(s3));
maxlen=max(maxlen,length(s4));

%for zero padding to equate the total number of samples 

s1=[s1 zeros(1,maxlen-length(s1))];
s2=[s2 zeros(1,maxlen-length(s2))];
s3=[s3 zeros(1,maxlen-length(s3))];
s4=[s4 zeros(1,maxlen-length(s4))];


%initial correlation fn for finding angle

[xc,lags] = xcorr(s2,s1);
[m,i] = max(abs(xc));
N1r = lags(i);
T1r = N1r/Fs;

[xc,lags] = xcorr(s3,s1);
[m,i] = max(abs(xc));
N2r = lags(i);
T2r = N2r/Fs;


[xc,lags] = xcorr(s4,s1);
[m,i] = max(abs(xc));
N3r = lags(i);
T3r = N3r/Fs;

%finding the quadrant in which source is present

if T1r>0

   if T3r<0 
    {
    q=4;

    t1 =-T3r;

    %[xc,lags] = xcorr(s4,s2);
    %[m,i] = max(abs(xc));
    %N2r = lags(i);
    %t2 = N2r/Fs;
    t2=-T3r+T2r;


    %[xc,lags] = xcorr(s4,s3);
    %[m,i] = max(abs(xc));
    %N3r = lags(i);
    %t3 = N3r/Fs;
    t3=-T3r+T2r;
    
    t4=0;
    disp(q);
    };
    else 
    {
    q=1;
         
    %[xc,lags] = xcorr(s1,s2);
    %[m,i] = max(abs(xc));
    %N1r = lags(i);
    %t2 = N1r/Fs;
    t2=-T1r;
    
    t3 = -T2r;


    %[xc,lags] = xcorr(s1,s4);
    %[m,i] = max(abs(xc));
    %N3r = lags(i);
    %t4 = N3r/Fs;
    t4=-T3r;
    
    t1=0;
    };
    endif;
  
else if T3r>0
    {
     q=2;
    
    t1 = -T1r;

    %[xc,lags] = xcorr(s2,s3);
    %[m,i] = max(abs(xc));
    %N2r = lags(i);
    %t3 = N2r/Fs;
    t3=-T2r+T1r;


    %[xc,lags] = xcorr(s2,s4);
    %[m,i] = max(abs(xc));
    %N3r = lags(i);
    %t4 = N3r/Fs;
    t4=-T3r+T1r;
    
    t2=0;
    };
    else 
    {
    q=3;
    
    %[xc,lags] = xcorr(s3,s1);
    %[m,i] = max(abs(xc));
    %N1r = lags(i);
    %t1 = N1r/Fs;
    t1=-T2r;

    %[xc,lags] = xcorr(s3,s2);
    %[m,i] = max(abs(xc));
    %N2r = lags(i);
    %t2 = N2r/Fs;
    t2=-T2r+T1r;


    %[xc,lags] = xcorr(s3,s4);
    %[m,i] = max(abs(xc));
    %N3r = lags(i);
    %t4 = N3r/Fs;
    t4=-T3r+T2r;
    
    t3=0;
    };
    endif;
end;


disp(q);



x_star =[x y z]; %Emitter position

p=[x1 x2 x3 x4;y1 y2 y3 y4;z1 z2 z3 z4]; %Sensor positions

%Time from emitter to sensor
%t_stars = sqrt(sum((p-diag(x_star)*ones(nDim, nSensors)).^2,1))/v;
t_stars=[t1 t2 t3 t4];

%Sensor closest to emittor
[~,c] = min(t_stars);

%Removing the time for wich the sensors did not know of the signal
t =t_stars-t_stars(c); %The actual timestamps the signals have to work with

ijs = 1:nSensors;
ijs(c) = [];
A = zeros(size(ijs,1), nDim);
b = zeros(size(ijs,1),1);
iRow = 0;
rankA = 0;
for i = ijs
    for j = ijs
        iRow = iRow + 1;
        A(iRow,:) = 2*(v*(t(j)-t(c))*(p(:,i)-p(:,c))'-v*(t(i)-t(c))*(p(:,j)-p(:,c))');
        b(iRow,1) = v*(t(i)-t(c))*(v*v*(t(j)-t(c))^2-p(:,j)'*p(:,j)) + (v*(t(i)-t(c))-v*(t(j)-t(c)))*p(:,c)'*p(:,c) +	v*(t(j)-t(c))*(p(:,i)'*p(:,i)-v*v*(t(i)-t(c))^2);    
        rankA = rank(A);
        if(rankA >= nDim)
            break;
        end;
    end;
    if(rankA >= nDim)
        break;
    end;
end;

x_star %Actual position of emitter
x_hat_inv = A\b %Calculated position of emitter
figure
x=x_hat_inv(1);
y=x_hat_inv(2);
plot(x,y,'r');
grid on
hold on

x=p(1,1);
y=p(2,1);
plot(x,y);
hold on

x=p(1,2);
y=p(2,2);
plot(x,y);
hold on

x=p(1,3);
y=p(2,3);
plot(x,y);
hold on

x=p(1,4);
y=p(2,4);
plot(x,y);
grid on 'r'
hold on;


