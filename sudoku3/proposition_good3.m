function s = proposition_good3(grid, row_not_def, col_not_def, mask_row, mask_col, mask_square, grid_init)
% grid: 9x9 matrix representing a full grid
% row_not_def: the row indices of the non-defined values
% col_not_def: the col indices of the non-defined values

% Swap two element that are not defined.
% The elements that cause conflics have a higher propability to be swapped. 

N = 9; % size of the grid
proba_take_conflic = 0.5;

row_to_swap = zeros(1, 1);
col_to_swap = zeros(1, 1);

% Next index where to store an element that raises a conflict
index4swap = 1;%length(col_not_def) + 1;

% Store the elements (once per conflic) that causes conflic
for row = 1:N
	for col = 1:N
        % Add the element the number of times it causes conflic on the row
        if grid_init(row, col) == 0
            for i = 1:mask_row(row, grid(row, col))
                row_to_swap(index4swap) = row;
                col_to_swap(index4swap) = col;
                index4swap = index4swap + 1;
            end
        end
        
        % Add the element the number of times it causes conflic on the
        % column
        if grid_init(row, col) == 0
            for i = 1:mask_col(col, grid(row, col))
                row_to_swap(index4swap) = row;
                col_to_swap(index4swap) = col;
                index4swap = index4swap + 1;
            end
        end
        
        % Add the element the number of times it causes conflic on the
        % square
        if grid_init(row, col) == 0
            square = floor((row-1) / 3) + floor((col-1) / 3) + 1;
            for i = 1:mask_square(square, grid(row, col))
                row_to_swap(index4swap) = row;
                col_to_swap(index4swap) = col;
                index4swap = index4swap + 1;
            end
        end
    end
end

% Make sure the to element have a different value
r1 = 1;
c1 = 1;
r2 = 1;
c2 = 1;
while grid(r1, c1) == grid(r2, c2)
    if rand() > proba_take_conflic && length(row_to_swap) > 0
        index2 = randi(length(row_to_swap));
        r1 = row_to_swap(index2);
        c1 = col_to_swap(index2);
    else
        index2 = randi(length(row_not_def));
        r1 = row_not_def(index2);
        c1 = col_not_def(index2);
    end
    if rand() > proba_take_conflic && length(row_to_swap) > 0
        index1 = randi(length(row_to_swap));
        r2 = row_to_swap(index1);
        c2 = col_to_swap(index1);
    else
        index1 = randi(length(row_not_def));
        r2 = row_not_def(index1);
        c2 = col_not_def(index1);
    end
end

tmp = grid(r1, c1);
grid(r1, c1) = grid(r2, c2);
grid(r2, c2) = tmp;

s = grid;

end
