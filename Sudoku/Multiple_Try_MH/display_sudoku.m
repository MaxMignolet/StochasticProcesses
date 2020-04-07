function display_sudoku(grid)

for i=0:2
	for k=0:24
		fprintf('-');
	end
	fprintf('\n');
	for j=1:3
		fprintf('|');
		for k=0:2
			for l=1:3
				fprintf(' %d', grid(i * 3 + j, k * 3 + l));
			end
			fprintf(' |');
		end
		fprintf('\n');
	end
end
for k=0:24
	fprintf('-');
end
fprintf('\n');
