function [p1, p2, Q_t] = Q1_1_1(time)

Q = [0 0.1 0.1 0.8 ; 1 0 0 0 ; 0.6 0 0.1 0.3 ; 0.4 0.1 0.5 0];

p1 = zeros(4, time);

p1(:, 1) = 0.25;

for i=2:time
    p1(:, i) = transpose(Q) * p1(:, i-1);
end

p2 = zeros(4, time);
p2(3, 1) = 1;

for i=2:time
    p2(:, i) = transpose(Q) * p2(:, i-1);
end

s = size(Q);
Q_t = zeros(s(1), s(2), time);
Q_t(:, :, 1) = Q;

for i=2:time
    Q_t(:, :, i) = Q * Q_t(:, :, i-1);
end

set(0,'defaultaxesfontsize',15);
set(0,'defaulttextfontsize',15);
set(0,'defaultlinelinewidth',1.5);
figure;
title({'Evolution de la distribution de probabilite', 'pour une distribution initiale uniforme'});
xlabel('Position t dans la chaine de Markov');
ylabel('Probabilite');
hold on;
t = 1:time;
for i=1:4
    plot(t, p1(i,:));
end
legend('Etat 1', 'Etat 2', 'Etat 3', 'Etat 4');

hold off
figure;
title({'Evolution de la distribution de probabilite', 'avec comme etat initial l''etat 3'});
xlabel('Position t dans la chaine de Markov');
ylabel('Probabilite');
hold on;
t = 1:time;
for i=1:4
    plot(t, p2(i,:));
end
hold off
legend('Etat 1', 'Etat 2', 'Etat 3', 'Etat 4');

end
