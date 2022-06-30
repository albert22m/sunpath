% code by u/ansariddle
% coordinates: 33.4° N, 111.9° W , Meridian: 105 (NO DAYLIGHT SAVINGS)
% Masters, Gilbert (2004) "Renewable and Efficient Electric Power Systems" - Page 409
clear all; close all; clc
Lat = 41.43; %Latitude
Lon = -111.9; %Longitude
Mer = -105; %Meridien (Constant if no DST)
n = 0:1/24:365; %Solar time
B = 360/364*(n-81); 
E = 9.87*sind(2*B) - 7.53*cosd(B) - 1.5*sind(B); %time shift
n = n + (4*(Mer - Lon) + E)/(60*24); %Solar Time to Clock Time
decl = 23.45*sind(360/365*(n - 81)); %declination
H = (0.5-mod(n,1))*24*15; %hours from noon
sinbeta = cosd(Lat).*cosd(decl).*cosd(H) + sind(Lat).*sind(decl); %sin of solar altitude
phis = asind(cosd(decl).*sind(H)./cosd(asind(sinbeta))); %solar azimuth
cond = cosd(H)>=tand(decl)/tand(Lat);
phis(~cond) = -phis(~cond)+sign(phis(~cond))*180; %correct azimuth
x = cosd(phis-90).*cosd(asind(sinbeta)); %normal x,y,z vector of sun position
y = sind(phis-90).*cosd(asind(sinbeta));
z = sinbeta;
scatter3(x,y,z,x*0+50,n,'filled');axis equal
view(-238,31);axis([-1 1 -1 1 0 1])
grid on;grid minor; [~,i] = max(decl-abs(H));[~,j] = min(decl); [~,k] = min(abs(decl)); hold on;
plot3(x(i+(-12:12)),y(i+(-12:12)),z(i+(-12:12)),'linewidth',2)
plot3(x(j+(-12:12)),y(j+(-12:12)),z(j+(-12:12)),'linewidth',2)
plot3(x(k+(-12:12)),y(k+(-12:12)),z(k+(-12:12)),'linewidth',2)
for n = (-7:6)
    text(x(i+n),y(i+n)+.1,z(i+n),num2str(13+n,'%i:00'))
end
quiver3([0 0],[0 0],[0 0],[0 1],[1 0],[0 0],.25,'k','linewidth',2)
hold off;text(0,.3,0,'N');text(.3,0,0,'E'); camproj('perspective');
h = colorbar; ylabel(h, 'Day of the Year')
colormap('hsv')
title(sprintf('Position of Sun in the Sky throughout the Year in Lat: %.1f^o and Lon: %.1f^o at Different Times of the day',Lat, Lon));
x = 1:1024; x = x'; colormap(circshift(flip(hsv(1024)),-270,1) - circshift(flip(hsv(1024)),-270,1).*heaviside(-.90+sin(24*pi/1024*(x-60))))
set(gca,'XTickLabel',[]);set(gca,'YTickLabel',[]);set(gca,'ZTickLabel',[])
legend('Solar Path','Solstice A','Solstice B','Equinox')