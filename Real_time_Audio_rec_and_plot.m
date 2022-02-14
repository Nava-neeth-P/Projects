clc;
clear all;
close all; 
Fs=44100;
dis=0.195;
Fs       = 44100 ;                                % // Sampling frequency: 10000 Hz
bits     = 16;                                % // Bits Per Sample: 16
channel  = 2;                                 % // Number of Channels: Mono
rec_time = 0.5;                                 % // Block of Sample Time: 5 sec
voice    = audiorecorder(Fs, bits, channel);  % // Recorder object
disp('Recording....');
angleres=0;
figure
for i=1:60
recordblocking(voice, rec_time);
x = getaudiodata(voice);
mag=max(abs(x(:,1)));
x(:,1)=x(:,1)./max(abs(x(:,1))); 
x(:,2)=x(:,2)./max(abs(x(:,2)));
%subplot(4,1,1); plot(x(:,1)); grid on;title('Signal 1'); xlabel('time(sec)-->');ylabel('s1-->');
%subplot(4,1,2); plot(x(:,2)) ;grid on;title('Signal 2');xlabel('time(sec)-->');ylabel('s2-->');
%
xdft = (1/length(x))*fft(x);
freq = -22050:(Fs/length(x)):22050-(Fs/length(x));
%subplot(4,1,3);plot(freq,abs(fftshift(xdft)));
%x = x/sqrt(sum(abs(x .^2)) / 1e6);
%x=audioread('G:\Main Project\Realtime Sound Source Seperation\test\MIX_TWO_SOURCE_1.wav');
mid=length(x(:,1));
[xc,lags] = xcorr(x(:,1),x(:,2));
[m,i] = max(abs(xc));
%[m,i]=findpeaks(abs(xc));
%if m>800 Ndres = lags(i);
%if(m>0.15*sum(abs(x(:,1)))) Ndres = lags(i);
if mag>0.01 Ndres = lags(i); %0.09 for detcting clap,0.01 for detecting a speaker
Tdres = Ndres/Fs;
angleres= -1*asin(340*((Tdres)/dis))*180/pi;
end
real(angleres);
res=exp(j*real(angleres)*(pi/180));
%subplot(4,1,4);
compass(res,'r');
hold off;
end
disp('Over...Over...');
%figure
%subplot(3,1,1); plot([1:5000]./44100,x(1:5000,1)); grid on;title('Signal 1'); xlabel('time(sec)-->');ylabel('s1-->');
%subplot(3,1,2); plot([1:5000]./44100,x(1:5000,2)) ;grid on;title('Signal 2');xlabel('time(sec)-->');ylabel('s2-->');
%subplot(3,1,3); 
%plot(lags./44100,abs(xc));xlim([-0.005,0.005]);grid on; title('Cross correlation');xlabel('lag(sec)-->');ylabel('Rx1.x2-->');
%stem(lags./44100,abs(xc));xlim([-0.0009,0.0002]);grid on; title('Cross correlation');xlabel('lag(sec)-->');ylabel('Rx1.x2-->');

