#!/usr/bin/octave
disp("La data fue obtenida desde 'investing.com'.\nSe tomó en cuenta el precio del bitcoin de cada día desde hace 51 días.\n Última vez actualizado el 20/09/19.");
% Obtención de la data
dat = csvread("dataset.csv");
% Se especifican las columnas cuyos datos son relevantes
%(fecha y precio)
col = dat(:, 1);
col2 = dat(:, 2);
data = [col col2];
% Evaluación de la data
disp("Veamos cómo está distribuida la data")
subplot(2, 5, 1);
%función definida en gdata.m que grafica la data pasada por parámetro.
gdata(col, col2);
title("Data")
%-----------------------Evaluación de funciones----------------------------
% Retorna un vector con los puntos en que será evaluada la función
x = linspace(0, size(col)(1));
%polinomio de grado 1, retorna vector con coeficientes.
poli = polyfit(col, col2, 1);
%evalúa el polinomio
y = polyval(poli, x);
subplot(2, 5, 2);
gdata(col, col2);
hold on;
plot(x, y);
title("Polinomio primer grado (Regresión lineal)");
vresult = polyval(poli, col);
disp("Errores en los modelos (desde 1er grado a 8vo)")
error = norm(col2 - vresult, 2)
%Generación de polinomios de hasta grado 8
for i = 2:8
  subplot(2, 5, i+1);
  gdata(col, col2)
  hold on;
	poli = polyfit(col, col2, i);
	y = polyval(poli, x);
	plot(x, y)
  s = strcat(int2str(i), "° ajuste polinomial");
  title(s)
  vresult = polyval(poli, col);
  error = norm(col2 - vresult, 2)
endfor