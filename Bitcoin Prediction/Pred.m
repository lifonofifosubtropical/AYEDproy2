#!/usr/bin/octave
disp("La data fue obtenida desde 'investing.com'.\nSe tomó en cuenta el precio del bitcoin de cada día desde hace 51 días.\nÚltima vez actualizado el 20/09/19.");
% Obtención de la data
dat = csvread("dataset.csv");
% Se especifican las columnas cuyos datos son relevantes
%(fecha y precio)
col = dat(:, 1);
col2 = dat(:, 2);
% Retorna un vector del tamaño de los puntos en que será evaluada la función, es decir, el tamaño de la columna.
x = linspace(0, size(col)(1));
%polinomio de grado 6, retorna vector con coeficientes.
poli = polyfit(col, col2, 6);
%evaluemos el polinomio para el día 27 de septiembre.
y = polyval(poli, 58)
printf("Se predice mediante ajuste polinomial de grado 6 que el precio del Bitcoin para el día 27/09/19 será de %d$ \n", y );