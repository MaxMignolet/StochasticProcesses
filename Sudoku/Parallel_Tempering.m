function [good_grid, nb_iteration, grids, f, found] = Parallel_Tempering(...
	initial_grid, beta, max_comp_time, max_chain_length)

tic

nb_chain = length(beta);

% generation d'une grille avec sous-carre et colonnes correctes
grid = zeros(9);
for i=1:9
	grid(i, [1 4 7]) = mod(i-1, 9) + 1;
	grid(i, [2 5 8]) = mod(i+2, 9) + 1;
	grid(i, [3 6 9]) = mod(i+5, 9) + 1;
end

grids = zeros(9, 9, nb_chain, max_chain_length);
for i=1:nb_chain
	grids(:, :, i, 1) = grid;
end
f = zeros(nb_chain, max_chain_length);
for i=1:nb_chain
	f(i, 1) = evalFunc(grids(:, :, i, 1), initial_grid);
end

i = 2;
found = false;
good_grid = zeros(9);
temp = 0;
while(i < max_chain_length + 1 && toc < max_comp_time && found == false)
	for j=1:nb_chain
		y = proposition(grids(:, :, j, i-1));
		f_y = evalFunc(y, initial_grid);
		alpha = min(1,  exp(-beta * (f_y - f(j, i-1))));
		
		u = rand();
		if u < alpha
			grids(:, :, j, i) = y;
			f(j, i) = f_y;
		else
			grids(:, :, j, i) = grids(:, :, j, i-1);
			f(j, i) = f(j, i-1);
		end
		if f(j, i) == 0
			found = true;
			good_grid = grids(:, :, j, i);
			temp = beta(j);
			break;
		end
	end
	
	% possible swap of states of two random system (different temperature)
	index = randsample(nb_chain, 2);
	p = min(1, exp((f(index(1), i) - f(index(2), i)) * ...
		(beta(index(1)) - beta(index(2)))));
	u = rand();
	if u < p
		tmp = grids(:, :, index(1), i);
		grids(:, :, index(1), i) = grids(:, :, index(2), i);
		grids(:, :, index(2), i) = tmp;
	end
	i = i + 1;
end

nb_iteration = i-1;
if found == true
	fprintf('Success\n');
	f = f(:, 1:i-1);
else
	fprintf('Failed \n');
end
fprintf('Beta: %d\n', temp);
% display_sudoku(good_grid)
end
