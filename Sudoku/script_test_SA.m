clearvars;

% load grids
s = load('sudokuBank.mat');
sudokuBank = s.sudokuBank;
nb_grids = 10; % size(sudokuBank, 1);
offset = 0; % pour ne pas reesayer des sudokus deja tente
% nb_trial = 10;
max_comp_time = 180;
max_chain_length = 2*10^6;
beta_init = [2 2.5];
beta_step = [10^-4 2*10^-5 4*10^-6];
nb_beta = length(beta_init);
nb_step = length(beta_step);

comp_time = zeros(nb_beta, nb_step, nb_grids);
nb_iteration = zeros(nb_beta, nb_step, nb_grids);

for i = 1:nb_beta
	fprintf('i = %d\n', i);
	for j=1:nb_step
		fprintf('\tj = %d\n', j);
		for k = (1:nb_grids) + offset
			fprintf('\t\tk = %d\n', k);
			t_start = tic;
			[~, ite, ~, f] = Simulated_Annealing(...
				sudokuBank(k, :, :), beta_init(i), beta_step(j), ...
				max_comp_time, max_chain_length);
			if f(end) == 0
				comp_time(i, j, k) = toc(t_start);
				nb_iteration(i, j, k) = ite;
			end
			fprintf('Pausing...\n');
			pause(60) % pour laisser le pc se reposer un peu
			fprintf('Restart!\n');
		end
	end
end

% traitement des donnees
mean_t = zeros(nb_beta, nb_step);
std_t = zeros(nb_beta, nb_step);
nb_unsolved = zeros(nb_beta, nb_step);

for i=1:nb_beta
	for j=1:nb_step
		x = comp_time(i, j, :) ~= 0;
		std_t(i, j) = std(comp_time(i, j, x), 1);
		x = comp_time(i, j, :) == 0;
		% pour remplacer les zeros par max_comp_time
		for k=1:length(x)
			if x(k) == 1
				comp_time(i, j, k) = max_comp_time;
				nb_unsolved(i, j) = nb_unsolved(i, j) + 1;
			end
		end
		mean_t(i, j) = mean(comp_time(i, j, :));
	end
end

% sauve le workspace
save('script_test_SA_workspace1.mat');
% faut changer le nom si on fait plusieurs execution!!!!!!!!!!!!!!!!
