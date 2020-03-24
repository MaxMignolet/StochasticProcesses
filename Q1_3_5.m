function [H, m] = Q1_3_5()

N = 10;
J = 1;
beta = 0.2;
chain_length = 10^4;
nb_chain = 100;

H = -20:2:20;
m = zeros(length(H), 1);

for i=1:length(H)
	m_temp = Q1_3_4(N, beta, J,  H, chain_length, nb_chain);
	m(i) = m_temp(end);
	%fprintf('%d-eme passage dans la boucle\n', i)
end

plot(H, m);

end
