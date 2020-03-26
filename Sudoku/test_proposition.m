% suppose sous carres ok et colonnes ok aussi
% juste lignes a corriger par permutation intra colonnes

% generation d'une grille avec sous-carre et colonnes correctes

grid = zeros(9);
for i=1:9
	grid(i, [1 4 7]) = mod(i-1, 9) + 1;
	grid(i, [2 5 8]) = mod(i+2, 9) + 1;
	grid(i, [3 6 9]) = mod(i+5, 9) + 1;
end

s = proposition(grid);
display_sudoku(s);
