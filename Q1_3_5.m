function [H, m] = Q1_3_5()

N = 10;
J = 1;
beta = 0.2;
H = -20:1:20;

chain_length = 10^4;
m = zeros(length(H), 1);

for i=1:length(H)
	[~, m_temp] = Q1_3_3b(N, beta, J,  H(i), chain_length);
	m(i) = m_temp(end);
	fprintf('%d-eme passage dans la boucle\n', i)
end

set(0,'defaultaxesfontsize',15);
set(0,'defaulttextfontsize',15);
set(0,'defaultlinelinewidth',1.5);
figure;
title({'Magnetisation moyenne en fonction', 'de l''intensite du champ magnetique externe'});
xlabel('Intensite du champ magnetique externe');
ylabel('Magnetisation');
hold on
plot(H, m);
hold off

end
