clearvars;

% load grids
s = load('sudokuBank.mat');
sudokuBank = s.sudokuBank;
nb_grids = 10; % size(sudokuBank, 1);
offset = 0; % pour ne pas reesayer des sudokus deja tente
% nb_trial = 10;
max_comp_time = 180;
max_chain_length = 2*10^6;
beta = [
	[1.5 3 4.5]
	[2 3 4]
	[2.5 3 3.5]
	];
nb_beta = length(beta);

comp_time = zeros(nb_beta, nb_grids);
nb_iteration = zeros(nb_beta, nb_grids);

for i = 1:nb_beta
	fprintf('i = %d\n', i);
	for j = (1:nb_grids) + offset
		fprintf('\tj = %d\n', j);
		t_start = tic;
		[~, ite, ~, f] = Parallel_Tempering(...
			sudokuBank(j, :, :), beta(i, :), max_comp_time, max_chain_length);
		if f(end) == 0
			comp_time(i, j) = toc(t_start);
			nb_iteration(i, j) = ite;
		end
		fprintf('Pausing...\n');
		pause(60) % pour laisser le pc se reposer un peu
		fprintf('Restart!\n');
	end
end

% traitement des donnees
mean_t = zeros(nb_beta, 1);
std_t = zeros(nb_beta, 1);
nb_unsolved = zeros(nb_beta, 1);

for i=1:nb_beta
	x = comp_time(i, :) ~= 0;
	std_t(i) = std(comp_time(i, x), 1);
	x = comp_time(i, :) == 0; % pour remplacer les zeros par max_comp_time
	for j=1:length(x)
		if x(j) == 1
			comp_time(i, j) = max_comp_time;
			nb_unsolved(i) = nb_unsolved(i) + 1;
		end
	end
	mean_t(i) = mean(comp_time(i, :));
end

% sauve le workspace
save('script_test_PT_workspace1.mat');
% faut changer le nom si on fait plusieurs execution!!!!!!!!!!!!!!!!
