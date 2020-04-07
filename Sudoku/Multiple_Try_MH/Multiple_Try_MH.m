function [good_grid, nb_iteration, grids, f] = Multiple_Try_MH()
max_chain_length = 2*10^6;
beta = -log(0.05); % to be tuned
p = 0.75; % parameter of the geometric distribution for nb_additional_step

% % initial_grid = zeros(9);

initial_grid = [
	[0 0 0 8 2 3 0 0 0];
	[2 5 3 0 0 0 0 0 8];
	[8 0 0 4 0 0 0 7 0];
	[1 0 9 0 7 0 3 0 0];
	[0 0 0 9 6 1 0 0 0];
	[0 0 2 0 3 0 9 0 7];
	[0 3 0 0 0 9 0 0 2];
	[9 0 0 0 0 0 6 8 1];
	[0 0 0 7 8 6 0 0 0];
	]; % hard grid

% initial_grid = [
% 	[0 0 6 1 0 0 0 0 0];
% 	[0 1 3 2 4 0 0 6 7];
% 	[0 0 8 0 5 0 0 1 4];
% 	[0 5 2 0 0 7 0 0 8];
% 	[1 0 0 0 2 0 0 0 5];
% 	[7 0 0 9 0 0 2 3 0];
% 	[2 9 0 0 7 0 4 0 0];
% 	[3 4 0 0 9 8 1 2 0];
% 	[0 0 0 0 0 2 7 0 0];
% 	]; % medium grid

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

grids = zeros(9, 9, max_chain_length);
grids(:, :, 1) = grid;
f = zeros(max_chain_length, 1);
f(1) = evalFunc(grids(:, :, 1), initial_grid);

i = 2;
while(i < max_chain_length + 1 && f(i-1) ~=0)
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
