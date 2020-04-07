function f = evalFunc2(grid)

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
for row = 1:N
	mask = zeros(1, N) - 1; % vector de taille 9 avec tous des -1 
	for col = 1:N
        nombre= grid(row, col);
		mask(nombre) = mask(nombre) + 1;%met à 0 si un element est rencintré est 1 si deux fois.
	end
	indices = mask > 0; %renvoie 1 si l'élement est + et 0 si - (on a un vecteur binaire)
	f = f + sum(mask(indices));
end

% Check the columns
for col = 1:N
	mask = zeros(N, 1) - 1; % vector de taille 9 avec tous des -1 
	for row = 1:N
        nombre= grid(row, col);
		mask(nombre) = mask(nombre) + 1;%met à 0 si un element est rencintré est 1 si deux fois.
	end
	indices = mask > 0; %renvoie 1 si l'élement est + et 0 si - (on a un vecteur binaire)
	f = f + sum(mask(indices));
end

% Check the squares
for square = 1:N
    shift_row = floor((square-1) / 3);
    shift_col = mod(square-1, 3);
    mask = zeros(N, 1) - 1; % vector de taille 9 avec tous des -1 
    for row = 1:3
        for col = 1:3
            nombre = grid(row + shift_row, col + shift_col);
            mask(nombre) = mask(nombre) + 1;%met à 0 si un element est rencintré est 1 si deux fois.
        end
        indices = mask > 0; %renvoie 1 si l'élement est + et 0 si - (on a un vecteur binaire)
        f = f + sum(mask(indices));
    end
end

end