clear all;
%% Solve a non co-op game between 3 players (2 attackers 1 defender)

%% Enter Inputs
% How many nodes?
na = 4;
% How are the physical nodes connected to cyber nodes?
A = [1 1 1 0 ; 0 1 1 1];
%Player resources. X(1,:) contains first set of resources to be used
    xa = [2;2;2];     xa2 = [2;2;2];        xd = [2;3;4];
X = [xa xa2 xd];
% What is the cost of each physical node to each player when down?(p1[alpha,beta..];p2...)
% A negative sign denotes defender. In this case costd is the only defender
cost = [1;.25];      cost2 = [.25;1];     costd = [-.75;-.75];
Cost = [cost cost2 costd];
% How many cyber nodes must be down for each physical node to be down
V = [1;1];

%% Create cost matrix based on all combinations that could be played between both players vs def
            [CA] = resourcecombos( na,X);
     for uu = 1:size(X,1)
      [matrix{uu}] = Gamebuild( na,{CA{X(uu,1)} CA{X(uu,2)} CA{X(uu,3)}},A,Cost,V)
            U = [length(CA{X(uu,2)});length(CA{X(uu,1)});length(CA{X(uu,3)})];%Vector input contains lengths of each strategy set
  [Aa{uu},payoff(:,uu),iterations(uu),err(uu)] = npg2(U',matrix{uu});
     end
%%The npg has been solved. payoff contains values for each player 
% In this case defenders resources were varied so we will plot over
% defenders changing resources.
cla;
plot(xd,payoff(1,:),'-+r')
hold on
plot(xd,payoff(2,:),':*g')
plot(xd,payoff(3,:),'-.xk')
legend('Payoff Player 1','Payoff Player 2','Payoff Defender')
title('Defender resources vs value of game')
xlabel('Defender resources')
ylabel('Value of n-person game')
hold off 


