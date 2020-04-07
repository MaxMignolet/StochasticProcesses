function [good_grid, nb_iteration, grids, f] = Parallel_Tempering()
max_chain_length = 2*10^6;
beta = [2.5, 3.5, 4.5]; % to be tuned
nb_chain = length(beta);

% % initial_grid = zeros(9);

% initial_grid = [
% 	[0 0 0 8 2 3 0 0 0];
% 	[2 5 3 0 0 0 0 0 8];
% 	[8 0 0 4 0 0 0 7 0];
% 	[1 0 9 0 7 0 3 0 0];
% 	[0 0 0 9 6 1 0 0 0];
% 	[0 0 2 0 3 0 9 0 7];
% 	[0 3 0 0 0 9 0 0 2];
% 	[9 0 0 0 0 0 6 8 1];
% 	[0 0 0 7 8 6 0 0 0];
% 	]; % hard grid

initial_grid = [
	[0 0 6 1 0 0 0 0 0];
	[0 1 3 2 4 0 0 6 7];
	[0 0 8 0 5 0 0 1 4];
	[0 5 2 0 0 7 0 0 8];
	[1 0 0 0 2 0 0 0 5];
	[7 0 0 9 0 0 2 3 0];
	[2 9 0 0 7 0 4 0 0];
	[3 4 0 0 9 8 1 2 0];
	[0 0 0 0 0 2 7 0 0];
	]; % medium grid

% initial_grid = [
% 	[4 0 6 3 8 0 0 2 0];
% 	[5 0 3 7 0 4 0 0 0];
% 	[0 0 0 9 0 0 8 4 3];
% 	[2 3 0 0 1 0 9 0 0];
% 	[0 4 0 0 0 0 5 7 1];
% 	[0 5 0 6 4 7 0 0 0];
% 	[9 0 1 4 0 8 3 0 0];
% 	[0 6 4 0 0 0 0 0 7];
% 	[8 0 5 1 0 3 0 9 2];
% 	]; % easy grid

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
temp = 0;
while(i < max_chain_length + 1 && found == false)
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
	p = min(1, (f(index(1), i) - f(index(2), i)) * ...
		(beta(index(1)) - beta(index(2))));
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
else
	fprintf('Failed \n');
end
fprintf('Temp: %d\n', temp);
display_sudoku(good_grid)
end
