function [good_grid, nb_iteration, grids, f] = Metropolis_Hastings(max_chain_length)

beta = 4; % to be tuned

initial_grid = [
	[1 0 0 0 0 0 0 0 0];
	[0 0 0 0 0 0 0 0 0];
	[0 0 0 0 0 0 0 0 0];
	[0 7 0 0 0 0 0 0 0];
	[0 0 0 0 0 0 0 0 0];
	[0 0 0 0 0 0 3 0 0];
	[0 0 0 0 0 0 0 0 0];
	[0 0 0 0 0 0 0 4 0];
	[0 0 0 0 0 0 0 0 0];
	];
% generation d'une grille avec sous-carre et colonnes correctes
grid = zeros(9);
for i=1:9
	grid(i, [1 4 7]) = mod(i-1, 9) + 1;
	grid(i, [2 5 8]) = mod(i+2, 9) + 1;
	grid(i, [3 6 9]) = mod(i+5, 9) + 1;
end

grids = zeros(9, 9, max_chain_length);
grids(:, :, 1) = grid;
f = zeros(max_chain_length, 1);
f(1) = evalFunc(grids(:, :, 1), initial_grid);

i = 2;
while(i < max_chain_length + 1 && f(i-1) ~=0)
	y = proposition(grids(:, :, i-1));
	f_y = evalFunc(y, initial_grid);
	alpha = min(1,  exp(-beta * (f_y - f(i-1))));
	
	u = rand();
	if u < alpha
		grids(:, :, i) = y;
		f(i) = f_y;
	else
		grids(:, :, i) = grids(:, :, i-1);
		f(i) = f(i-1);
	end
	i = i + 1;
end

good_grid = grids(:, :, i-1);
nb_iteration = i-1;
if f(nb_iteration) == 0
	fprintf('Success\n');
else
	fprintf('Failed \nEval func: %d\n', f(end));
end

end
