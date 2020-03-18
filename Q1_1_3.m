function n = Q1_1_3(time)

Q = [0 0.1 0.1 0.8 ; 1 0 0 0 ; 0.6 0 0.1 0.3 ; 0.4 0.1 0.5 0];

s = zeros(1, time); %vector of states
n = zeros(4, time);

[V, ~] = eig(transpose(Q));
distrib_stat = V(:, 1) / norm(V(:, 1), 1);
cdp = cumsum(distrib_stat);
temp = rand();
if(temp < cdp(1))
    s(1) = 1;
elseif(temp < cdp(2))
    s(1) = 2;
elseif(temp < cdp(3))
    s(1) = 3;
else
    s(1) = 4;
end

n(s(1), 1) = 1;

temp = zeros(1, 4);
for i=2:time
    for j=1:4
        temp(j) = Q(s(i-1), j);
    end
    temp = cumsum(temp);
    p = rand();
    if(p<temp(1))
        s(i) = 1;
    elseif(p < temp(2))
        s(i) = 2;
    elseif(p < temp(3))
        s(i) = 3;
    else
        s(i) = 4;
    end
    n(:, i) = n(:, i-1);
    n(s(i), i) = n(s(i), i) + 1;
    n(:, i) = n(:, i);
end

for i=2:time
    n(:, i) = n(:, i) / i;
end

t = 1:time;
%figure;
set(0,'defaultaxesfontsize',15);
set(0,'defaulttextfontsize',15);
set(0,'defaultlinelinewidth',1.5);
semilogx(0);
for i = 1:4
    semilogx(t, n(i,:));
	hold on;
end
hold off

title({'Nombre de realisation des etats en fonction de la longueur', 'de la chaine pour une realisation donnee'});
xlabel('Longueur de la chaine');
ylabel({'Nombre de r?alisations', '(rapporte a la longueur de la chaine)'});
legend('Etat 1', 'Etat 2', 'Etat 3', 'Etat 4');

end
