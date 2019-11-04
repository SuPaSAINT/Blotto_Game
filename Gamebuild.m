function [matrix] = Gamebuild( na,CA,Aa,Cost,V)
%% Three player game matrix based on blotto resource combinations
p = 1; z = 0;
Ca = CA{1}; Ca2 = CA{2};Cd = CA{3};
Ld = length(Cd);La = length(Ca);La2 = length(Ca2);
% For each strategy set in player 2 combinations
for oo = 1:La2
    % For each strategy set in player 1 combinations 
    for jj = 1:La
        % For each strategy set in defenders combinations
        for kk = 1:Ld
        %Check if combined strategies takes over a node
            for ll = 1:na
                if Ca(jj,ll)+Ca2(oo,ll) <= Cd(kk,ll)
                    H = 0;
                elseif Ca(jj,ll)+Ca2(oo,ll) > Cd(kk,ll)
                    H = 1;
                end
                % z contains success or failure of each c-nodes attacks from combined
                % efforts
                z(ll) = H;
            end
            % Aa helps relate interconnectivity of physical nodes. 
        % If y(1) = 2; physical node 1 suffered 2 cyber node losses this combo
                  y = Aa*z';
            for ii = 1:length(y) % Compare nodes with threshold values
                if y(ii) >= V(ii)
                    Y(ii) = 1;
                else
                    Y(ii) = 0;
                end
        %Y now contains 1 if p-node is taken down and 0 if not
            end         
% Each player values physical nodes differently
% If player mm is an attacker, reward nodes being down.(Y(ii) = 1)
            for mm = 1:size(Cost,2)
                if sum(Cost(:,mm)) > 0
                  C(mm) = Y*Cost(:,mm); 
                else
 %  Otherwise a defender gets rewarded when cyber nodes are not
 %  successfully taken down.
                for ii = 1:length(Y)
                    if Y(ii) == 0
                        C10(ii) = abs(Cost(ii,mm));
                    elseif Y(ii) == 1
                        C10(ii) = 0;
                    end
                end
 
                C(mm) = sum(C10);
                end
            end   

        % Build cost matrix.  
                matrix(p,:) = C;
                p = p+1;
        end
    end
   
end
end