function [f, mask_row, mask_col, mask_square] = evalFunc3(grid)

% grid: a 9x9 matrix representing a complete grid
% initial_grid: a grid where all non zero elements are the initially fixed
% digits

% returns the number of digits appearing twice in the line/colum/square
% of the grid.
% If a digit appears three times in a same line/column/square, it will be 
% counted as 2 duplicates

N = 9; % size of the grid

f = 0;

% Check the rows
mask_row = zeros(N, N) - 1;
for row = 1:N
	for col = 1:N
        nombre= grid(row, col);
		mask_row(row, nombre) = mask_row(row, nombre) + 1;%met à 0 si un element est rencintré est 1 si deux fois.
	end
	indices = mask_row(row, :) > 0; %renvoie 1 si l'élement est + et 0 si - (on a un vecteur binaire)
	f = f + sum(mask_row(row, indices));
end

% Check the columns
mask_col = zeros(N, N) - 1;
for col = 1:N
	for row = 1:N
        nombre= grid(row, col);
		mask_col(col, nombre) = mask_col(col, nombre) + 1;%met à 0 si un element est rencintré est 1 si deux fois.
	end
	indices = mask_col(col, :) > 0; %renvoie 1 si l'élement est + et 0 si - (on a un vecteur binaire)
	f = f + sum(mask_col(col, indices));
end

% Check the squares
mask_square = zeros(N, N) - 1;
for square = 1:N
    shift_row = 3*floor((square-1) / 3);
    shift_col = 3*mod(square-1, 3);
    for row = 1:3
        for col = 1:3
            nombre = grid(row + shift_row, col + shift_col);
            mask_square(square, nombre) = mask_square(square, nombre) + 1;%met à 0 si un element est rencintré est 1 si deux fois.
        end
        indices = mask_square(square, :) > 0; %renvoie 1 si l'élement est + et 0 si - (on a un vecteur binaire)
        f = f + sum(mask_square(square, indices));
    end
end

end
