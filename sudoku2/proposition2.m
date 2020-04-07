function s = proposition2(grid, row_not_def, col_not_def)
% grid: 9x9 matrix representing a full grid
% row_not_def: the row indices of the non-defined values
% col_not_def: the col indices of the non-defined values

% swap randomly two element that are not defined

index1 = randi(length(row_not_def));
index2 = randi(length(row_not_def));

% Make sure the to element have a different value
while grid(row_not_def(index1), col_not_def(index1)) == grid(row_not_def(index2), col_not_def(index2))
    index1 = randi(length(row_not_def));
    index2 = randi(length(row_not_def));
end

tmp = grid(row_not_def(index1), col_not_def(index1));
grid(row_not_def(index1), col_not_def(index1)) = grid(row_not_def(index2), col_not_def(index2));
grid(row_not_def(index2), col_not_def(index2)) = tmp;

s = grid;

end
