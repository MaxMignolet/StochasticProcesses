function M = Q1_3_4(N, beta, J,  H, chain_length, nb_chain)

m = zeros(chain_length, nb_chain);

for i=1:nb_chain
	[~, m(:, i)] = Q1_3_3(N, beta, J,  H, chain_length);
end

M = zeros(chain_length, 1);
centile_05 = zeros(chain_length, 1);
centile_95 = zeros(chain_length, 1);
for i=1:chain_length
	M(i) = mean(m(i, :));
	centile_05(i) = quantile(m(i, :), 0.05);
	centile_95(i) = quantile(m(i, :), 0.95);
end

figure;
hold on
plot(M);
plot(centile_05);
plot(centile_95);
hold off

end
