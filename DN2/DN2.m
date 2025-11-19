clear; clc; close all;

%% 1) Branje vozlišč
fid = fopen('vozlisca_temperature_dn2_20.txt','r');
fgetl(fid);

vr = fgetl(fid); Nx = sscanf(vr,'st. koordinat v x-smeri: %f');
vr = fgetl(fid); Ny = sscanf(vr,'st. koordinat v y-smeri: %f');
vr = fgetl(fid); Nv = sscanf(vr,'st. vseh vozlisc: %f');

podatki = readmatrix('vozlisca_temperature_dn2_20.txt','NumHeaderLines',4);
x_v = podatki(:,1); 
y_v = podatki(:,2); 
T_v = podatki(:,3);
fclose(fid);

%% 2) Branje celic
fid = fopen('celice_dn2_20.txt','r');
fgetl(fid);
vr = fgetl(fid); Nc = sscanf(vr,'st. celic: %f');
cel = readmatrix('celice_dn2_20.txt','NumHeaderLines',2);
fclose(fid);

%% 3) Mreža
x_u = unique(x_v);
y_u = unique(y_v);
Tmat = reshape(T_v,[Nx,Ny])';

%% 4) scatteredInterpolant
xq = 0.403; 
yq = 0.503;

tic;
F1 = scatteredInterpolant(x_v,y_v,T_v,'linear');
T1 = F1(xq,yq);
t1 = toc;

fprintf("[1] scattered -> %.6f °C, čas = %.6f s\n", T1, t1);

%% 5) griddedInterpolant

tic;
F2 = griddedInterpolant({y_u,x_u},Tmat,'linear');
T2 = F2(yq,xq);
t2 = toc;

fprintf("[2] gridded -> %.6f °C, čas = %.6f s\n", T2, t2);

%% 6) Bilinearna

tic;
ix = find(x_u <= xq,1,'last');
iy = find(y_u <= yq,1,'last');

x1 = x_u(ix);   x2 = x_u(ix+1);
y1 = y_u(iy);   y2 = y_u(iy+1);

T11 = Tmat(iy,ix);
T21 = Tmat(iy,ix+1);
T12 = Tmat(iy+1,ix);
T22 = Tmat(iy+1,ix+1);

K1 = (x2-xq)/(x2-x1)*T11 + (xq-x1)/(x2-x1)*T21;
K2 = (x2-xq)/(x2-x1)*T12 + (xq-x1)/(x2-x1)*T22;

T3 = (y2-yq)/(y2-y1)*K1 + (yq-y1)/(y2-y1)*K2;

t3 = toc;

fprintf("[3] bilinear -> %.6f °C, čas = %.6f s\n", T3, t3);

%% 7) Največja T

[Tmax, idx] = max(T_v);
fprintf("Tmax = %.6f °C pri (%.6f , %.6f)\n", Tmax, x_v(idx), y_v(idx));
