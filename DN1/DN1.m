clc; clear; close all;

datoteka = fopen('naloga1_1.txt', 'r');
podatek = fgetl(datoteka);
info = fgetl(datoteka);

C = textscan(datoteka, '%f');
t = C{1};
fclose(datoteka);

datoteka = fopen('naloga1_2.txt', 'r');
prva_vrstica = fgetl(datoteka);
st_podatkov = sscanf(prva_vrstica, 'stevilo_podatkov_P: %f');

P = zeros(st_podatkov,1);
for i = 1:st_podatkov
    vrstica = fgetl(datoteka);
    P(i) = str2double(vrstica);
end
fclose(datoteka);

figure;
plot(t, P, 'LineWidth', 1.5);
xlabel('t [s]');
ylabel('P [W]');
title('graf P(t)');
grid on;
axis([0 max(t) 0 1.1*max(P)]);

n = length(t);
integral_trapez = 0;

for i = 1:n-1
    delta_t = t(i+1) - t(i);
    integral_trapez = integral_trapez + (P(i) + P(i+1)) * delta_t / 2;
end

fprintf('Integral P(t) po trapezni metodi = %.4f\n', integral_trapez);

integral_matlab = trapz(t, P);
fprintf('Integral P(t) z MATLAB funkcijo trapz = %.4f\n', integral_matlab);
