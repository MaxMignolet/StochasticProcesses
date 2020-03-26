function h = evalFunc(grid, initial_grid)

% grid: a 9x9 matrix representing a complete grid
% initial_grid: a grid where all non zero elements are the initially fixed
% digits

% returns the number f+g
% f is the number of digits appearing twice in the lines of the grid
% if a digit appears three times in a same line, counted as 2 duplicates
% g is twice the number of mismatching fixed digits

N = 9; % size of the grid

f = 0;
for i=1:N
	mask = zeros(1, N) - 1;
	for j=1:N
		mask(grid(i, j)) = mask(grid(i, j)) + 1;
	end
	indices = mask > 0;
	f = f + sum(mask(indices));
end

digits_to_check = initial_grid > 0;
g = sum(grid(digits_to_check) ~= initial_grid(digits_to_check));

h = f + g;

end
