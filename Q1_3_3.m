
function [m, M] = Q1_3_3(N, beta, J,  H, chain_length)

s = zeros(chain_length, N); %vector state
%generating initial state at random with null average magnetisation
s(1, :) = [1 1 1 1 1 1 1 1 1 1];
s(1, randsample(N, round(N/2))) = -1;

m = zeros(chain_length, 1); % corresponding average magnetisation for ... 
	% each state
m(1) = mean(s(1, :));

for i=2:chain_length
	s(i, :) = s(i-1, :);
	j = randi(N); % particle to flip
	if(j > 1)
		l_neighboor = s(i, j-1);
	else
		l_neighboor = 0;
	end
	if(j < N)
		r_neighboor = s(i, j+1);
	else
		r_neighboor = 0;
	end
	alpha = min(1, exp(-2 * beta * s(i, j) * ...
		(J * (l_neighboor + r_neighboor) + H)));
	% alpha is the acceptation probability
	u = rand();
	if(u < alpha)
		s(i, j) = flip(s(i, j));
	end
	m(i) = mean(s(i, :));
end

M = zeros(chain_length, 1); % evolutive estimated average magnetisation

for i=2:chain_length
	M(i) = mean(m(1:i, :));
end

% plot(M);

end
function t = flip(s)
	if(s == 1)
		t = -1;
	else
		t = 1;
	end
end
