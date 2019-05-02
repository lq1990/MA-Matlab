X = [1 2
        1 3
         1 -1];
Y = [1;-2;3];
% W = (X' * X)^-1 * X' * Y
W = inv(X' * X) * X' * Y;
% W = X\Y;
b = W(1,1);
w = W(2,1);
figure;
plot(X(:,2),Y,'*', 'LineWidth',10); grid on; hold on;

xx = -1:0.1:3;
plot(xx, w*xx+b);
%%
X = [1 2
        1 3
         1 -1];
Y = [1;-2;3];
% W = (X' * X)^-1 * X' * Y
% W = inv(X' * X) * X' * Y;
W = X\Y;
b = W(1,1);
w = W(2,1);
Y_model =  X * W;
figure;
plot(X(:,2),Y,'*', 'LineWidth',10); grid on; hold on;
plot(X(:,2),Y_model, 'o');
xx = -1:0.1:3;
plot(xx, w*xx+b);