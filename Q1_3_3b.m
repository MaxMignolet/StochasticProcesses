
function [m, M] = Q1_3_3b(N, beta, J,  H, chain_length)

s = [1 -1 1 -1 1 -1 1 -1 1 -1]; % vector state
% generated at random

m = zeros(1, chain_length); % corresponding average magnetisation for ... 
	% each state
m(1) = mean(s);

for i=2:chain_length
	j = randi(N); % particle to flip
	if(j > 1)
		l_neighboor = s(j-1);
	else
		l_neighboor = s(N);
	end
	if(j < N)
		r_neighboor = s(j+1);
	else
		r_neighboor = s(1);
	end
	alpha = min(1, exp(-2 * beta * s(j) * ...
		(J * (l_neighboor + r_neighboor) + H)));
	% alpha is the acceptation probability
	u = rand();
	if(u < alpha)
		s(j) = flip(s(j));
	end
	m(i) = mean(s);
end

M = mean(m); % evolutive estimated average magnetisation

end
function t = flip(s)
	if(s == 1)
		t = -1;
	else
		t = 1;
	end
end
