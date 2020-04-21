function [good_grid, nb_iteration, grids, f] = Multiple_Try(...
	initial_grid, beta, p, max_comp_time, max_chain_length)

tic

% p: parametre pour la distribution geometrique pour nb_additional_step

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
while(i < max_chain_length + 1 && toc < max_comp_time && f(i-1) ~=0)
	y = proposition(grids(:, :, i-1));
	nb_additional_step = random('Geometric', p);
	for j=1:nb_additional_step
		y = proposition(y);
	end
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
	f = f(1:i-1);
else
	fprintf('Failed \n');
end
fprintf('Eval func: %d\n', f(nb_iteration));
display_sudoku(good_grid)
end
