clear all; clc; close all; format short

interval = 1e6;
xt = linspace(0, 2*pi*365.15, interval);
xd = linspace(0, 2*pi, interval);

axis = 23.435; %23.435
lambda = 41.433; %41.433
delta = (deg2rad(axis))*sin(xd-pi/2);

y = deg2rad(90-lambda)*sin(xt-pi/2);
xh = xd/(2*pi)*365.15;
yd = rad2deg(y) + rad2deg(delta);

figure(1)
plot(xh, yd, "-m", "LineWidth", 1)
yline(0, "-k", "LineWidth", 1.5);
yline(-6, "-b", "LineWidth", 2);
yline(-12, "-g", "LineWidth", 2);
yline(-18, "-r", "LineWidth", 2);
yline(90, "-.r", "LineWidth", 1.5);
xline(90, "-k", "LineWidth", 1);
xline(182, "-k", "LineWidth", 1);
xline(276, "-k", "LineWidth", 1);
xlim([0, 365.15])
set(gcf, "Name", "Solar altitude")

xtxt = [15, 106.25, 197.5, 288.75];
ytxt = linspace(75, 75, 4);
str = ["Winter", "Spring", "Summer", "Fall"]; 
text(xtxt, ytxt, str, "FontSize", 12)
legend("Sun path", "Official rise/set", "Civil rise/set", "Nautical rise/set", "Astronomical rise/set", "Zenith")

hour = 0;
for i = 1:length(yd)
    if yd(i) >= 0
        hour = hour + 365.15/interval;
    end
end
disp("--- YEAR -------------------------")
disp("Average sun hour: " + hour + " day")
fprintf("\n")

win = 0;
for i = 1:round(90/365.15*interval)
    if yd(i) >= 0
        win = win + 365.15/interval;
    end
end
disp("--- WINTER -----------------------")
disp("Average sun hour in winter: " + win + " day")
disp("Average sun hour per day in winter: " + win/90*24 + " h")
fprintf("\n")

spr = 0;
for i = round(90/365.15*interval):round(182/365.15*interval)
    if yd(i) >= 0
        spr = spr + 365.15/interval;
    end
end
disp("--- SPRING -----------------------")
disp("Average sun hour in spring: " + spr + " day")
disp("Average sun hour per day in spring: " + spr/(182 - 90)*24 + " h")
fprintf("\n")

sum = 0;
for i = round(182/365.15*interval):round(276/365.15*interval)
    if yd(i) >= 0
        sum = sum + 365.15/interval;
    end
end
disp("--- SUMMER -----------------------")
disp("Average sun hour in summer: " + sum + " day")
disp("Average sun hour per day in summer: " + sum/(276 - 183)*24 + " h")
fprintf("\n")

fall = 0;
for i = round(276/365.15*interval):round(365.15/365.15*interval)
    if yd(i) >= 0
        fall = fall + 365.15/interval;
    end
end
disp("--- FALL -------------------------")
disp("Average sun hour in fall: " + fall + " day")
disp("Average sun hour per day in fall: " + fall/(365.15 - 276)*24 + " h")
fprintf("\n")

diary = [0];
day = 0;
for i = 1:interval
    if yd(i) >= 0
        day = day + 365.15/interval;
    else
        if day ~= 0
            diary(end + 1) = day;
            day = 0;
        end
    end
end
diary(diary == 0) = []; diary = 24*diary; low = max(yd) - 2*axis; shp = 1/tan(deg2rad(max(yd))); shl = 1/tan(deg2rad(low)); 
disp("--- GENERAL DATA -----------------")
disp("Longest day: " + max(diary) + " h        Highest azimut: " + max(yd) + char(176) + "        Shadow ratio: " + shp)
disp("Shortest day: " + min(diary) + " h        Lowest azimut:  " + low + char(176) + "        Shadow ratio: " + shl)
fprintf("\n")

figure(2)
xx = [1:length(diary); 1:length(diary)];
yy = [diary; diary];
zz = zeros(size(xx));
hs = surf(xx,yy,zz,yy,'EdgeColor','interp', "LineWidth", 3);
colormap('hsv')
xlim([1, 365])
set(gcf, "Name", "Hours of sun")
view(2)

azi = [0];
counter = 1;
for counter = 1:365
    i = [round(1e6/365.15*(counter - 1)) + 1 : round(1e6/365.15*(counter))];
        azi(end + 1) = max(yd(i));
end
azi(azi == 0) = [];

figure(3)
plot(1:365, azi, "-", "Color", "#F5D806", "LineWidth", 2)
xlim([1, 365.15])
set(gcf, "Name", "Daily altitude at azimut")
yline(90, "-.", "Color", "#FF5100", "LineWidth", 1.5);
xtxt = [20, 20];
ytxt = [90-5, 90-8];
str = ["Max altitude = " + max(yd) + char(176), "Min altitude =  " + low + char(176)]; 
text(xtxt, ytxt, str, "FontSize", 12)

shadow = tan(deg2rad(azi)).^(-1);

if lambda > 66.564
    shadow(shadow <= 0) = [NaN];
end

figure(4)
plot(1:365, shadow, "-k", "LineWidth", 2)
area(shadow)
color = [0 0.5 1];
colororder(color)
xlim([1, 365.15])
yline(0, "-.k", "LineWidth", 1.5);
set(gcf, "Name", "Shadow ratio at azimut")

