function s = proposition(grid)
% grid: 9x9 matrix representing a full grid

% choose a column at random
% choose two digits at random
% permute the two digits

col = randi(9);
indices_to_permute = randsample(9, 2);
lin_1 = indices_to_permute(1);
lin_2 = indices_to_permute(2);
digit_1 = grid(lin_1, col);
digit_2 = grid(lin_2, col);

grid(lin_1, col) = digit_2;
grid(lin_2, col) = digit_1;

% numero des sous carre selon la verticale (1, 2, 3)
switch lin_1
	case {1, 2, 3}
		subsquare_1 = 1;
	case {4, 5, 6}
		subsquare_1 = 2;
	case {7, 8, 9}
		subsquare_1 = 3;
end

switch lin_2
	case {1, 2, 3}
		subsquare_2 = 1;
	case {4, 5, 6}
		subsquare_2 = 2;
	case {7, 8, 9}
		subsquare_2 = 3;
end
	
if subsquare_1 == subsquare_2
	s = grid;
	return; % nothing more to do
end

% indices dans les sous carre selon la verticale
sub_indices_1 = (subsquare_1 - 1)*3 + 1: subsquare_1 * 3;
sub_indices_2 = (subsquare_2 - 1)*3 + 1: subsquare_2 * 3;
% les 2 autres colonnes appartenants aux memes sous carr?s que col
columns = zeros(1, 2);
columns(1) = col - mod(col-1, 3) + mod(mod(col-1, 3) + 1, 3);
columns(2) = col - mod(col-1, 3) + mod(mod(col-1, 3) + 2, 3);

% lin_x et col_x sont en coord relatives
% pour avoir coord absolues:
%	ligne = sub_indices_2(lin_a)
%	colonne = columns(col_a)
[lin_a, col_a] = find(grid(sub_indices_2, columns) == digit_1);
[lin_b, col_b] = find(grid(sub_indices_1, columns) == digit_2);

if col_a == col_b
	grid(sub_indices_2(lin_a), columns(col_a)) = digit_2;
	grid(sub_indices_1(lin_b), columns(col_b)) = digit_1;
else
	% nous allons devoir trouver un troisieme nombre ? permuter
	do = true;
	lin_c = randi(3);
	col_c = col_a;
	while do % mathematiquement: maximum 3 iterations
		lin_c = mod(lin_c, 3) + 1;
		digit_c = grid(sub_indices_1(lin_c), columns(col_c));
		
		digit_d = digit_c;
		[lin_d, ~] = find(grid(sub_indices_2, columns(col_b)) == digit_d);
		col_d = col_b;
		if lin_d
			break;
		end
	end
	%permutation
	grid(sub_indices_2(lin_a), columns(col_a)) = digit_c;
	grid(sub_indices_1(lin_c), columns(col_c)) = digit_1;
	
	grid(sub_indices_1(lin_b), columns(col_b)) = digit_d;
	grid(sub_indices_2(lin_d), columns(col_d)) = digit_2;
end

s = grid;

end
