function MatingPool = MatingSelection(Population,RefPoint,Range)
    global PopCon 
%% Calculate the degree of violation of each solution
    CV = sum(max(0,PopCon),2);

    %% Calculate the fitness of each feasible solution based on IGD-NS
    if sum(CV==0) > 1
        % Calculate the distance between each solution and point
        N = sum(CV==0);
        %Distance    = CalDistance(Population(CV==0).objs-repmat(Range(1,:),N,1),RefPoint);
        objs = CalObj(Population);
        % plot3(objs(:,1),objs(:,2),objs(:,3),'ro')
        % hold on
        % plot3(RefPoint(:,1),RefPoint(:,2),RefPoint(:,3),'g*')
        Distance    = CalDistance(objs([CV == 0],:)-repmat(Range(1,:),N,1),RefPoint); % 都减去各维度的最小值
        Convergence = min(Distance,[],2);    % 对每一行排序，是每一行的最小的索引(第几列数) 每一个Pop到Ref的最近距离
        [dis,rank]  = sort(Distance,1);      % 对每一列从小到大从上到下排序，
        % Calculate the fitness of noncontributing solutions
        % 对于计算非贡献点的适应度，根据公式，只影响IGD-NS的第二项，也就是非贡献点到离它最近的参考点的距离
        % 所以，可以先求总和 METRIC，然后计算哪个点的适应度，只要减去这个非贡献点到离它最近的参考点的距离即可
        Noncontributing = true(1,N);
        Noncontributing(rank(1,:)) = false;  % 离参考点最近的Population的点为贡献点
        METRIC   = sum(dis(1,:)) + sum(Convergence(Noncontributing)); % 原论文的 IGD-NS(X,Y)
        fitness  = inf(1,N);
        fitness(Noncontributing) = METRIC - Convergence(Noncontributing);
        % Calculate the fitness of contributing solutions
        for p = find(~Noncontributing)            % 贡献点的索引
            temp = rank(1,:) == p;                % 离贡献点p最近的参考点为1，其他为0
            noncontributing = false(1,N);         % 
            noncontributing(rank(2,temp)) = true; % 离贡献点p最近的参考点，离此参考点第二近的点为真(标记为新的贡献点)
            noncontributing = noncontributing & Noncontributing; 
            % 为真意味着：这个点在原来是非贡献点，现在因为删除了p点，变成了贡献点，因此，就要减去原来是非贡献点时加的
            % 那个到最近的Ref的距离【sum(Convergence(noncontributing))】，加上变成贡献点时，
            % 对应的Ref到此点的距离【sum(dis(2,temp))】，再减去删去因为p点所增加的量【sum(dis(1,temp))】。
            fitness(p) = METRIC - sum(dis(1,temp)) + sum(dis(2,temp)) - sum(Convergence(noncontributing));
        end
    else
        fitness = zeros(1,sum(CV==0));
    end

    %% Combine the fitness of feasible solutions with the fitness of infeasible solutions
    Fitness = -inf(1,length(Population));
    Fitness(CV==0) = fitness;
    
    %% Binary tournament selection
    MatingPool = TournamentSelection(2,length(Population),CV,-Fitness);
end