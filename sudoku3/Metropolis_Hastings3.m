function [good_grid, nb_iteration, grids, f] = Metropolis_Hastings3()
close all;
max_chain_length = 10^5;
beta = -log(0.05) % to be tuned

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
% 	[0 0 0 7 8 6 6 0 0];
% 	]; % hard grid

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
% 	];

% Compute the number of element missing for each value.
% So if there is already six times 1 in the grid, there missing three 1.
number2add = zeros(1, 9) + 9;

% Store all the index of the 0 element.
[row_not_def, col_not_def] = find(initial_grid == 0);
nb_element_not_def = length(row_not_def);

% Decrement each time an element is found
for row = 1:9
    for col = 1:9
        if initial_grid(row, col) > 0
            number2add(initial_grid(row, col)) = number2add(initial_grid(row, col)) - 1;
        end
    end
end

% generation d'une grille avec sous-carre et colonnes correctes
grid = initial_grid;

% Put a random number for all element with zero value, but make sure that
% there are 9 elements of each value.

% keep a copy
row_not_def_c = row_not_def;
col_not_def_c = col_not_def;

% Index of the first value to set
index = 1;

for i=1:nb_element_not_def
    % Take a random cell from the ones not initialized
    element = randi(length(row_not_def_c));
    
    % Define its value
    while number2add(index) == 0
        index = index + 1;
    end
    % Decrement the number of element that has value that has yet to be set
    number2add(index) = number2add(index) - 1;
        
    % Set the value
	grid(row_not_def_c(element), col_not_def_c(element)) = index;
    % Remove the not defined element
    row_not_def_c(element) = [];
    col_not_def_c(element) = [];
end

% Vector d'etats
grids = zeros(9, 9, max_chain_length);
% On stock le premier etat
grids(:, :, 1) = grid;
% on choppe le score et on le stocke
f = zeros(max_chain_length, 1);
[f(1), mask_row, mask_col, mask_square] = evalFunc3(grids(:, :, 1));

i = 2;
while(i <= max_chain_length )
	y = proposition3(grids(:, :, i-1), row_not_def, col_not_def, mask_row, mask_col, mask_square, initial_grid);
	[f_y, mask_row, mask_col, mask_square] = evalFunc3(y);
	if f_y == 0
		grids(:, :, i) = y;
		f(i) = f_y;
		i = i + 1;
        break;
   	end
    

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
	fprintf('Failed \n');
end
fprintf('Eval func: %d\n', f(nb_iteration));
figure();
plot(f(1:i-1));
display_sudoku(good_grid);
end
