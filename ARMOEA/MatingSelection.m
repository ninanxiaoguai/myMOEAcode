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
        Distance    = CalDistance(objs([CV == 0],:)-repmat(Range(1,:),N,1),RefPoint); % ����ȥ��ά�ȵ���Сֵ
        Convergence = min(Distance,[],2);    % ��ÿһ��������ÿһ�е���С������(�ڼ�����) ÿһ��Pop��Ref���������
        [dis,rank]  = sort(Distance,1);      % ��ÿһ�д�С������ϵ�������
        % Calculate the fitness of noncontributing solutions
        % ���ڼ���ǹ��׵����Ӧ�ȣ����ݹ�ʽ��ֻӰ��IGD-NS�ĵڶ��Ҳ���Ƿǹ��׵㵽��������Ĳο���ľ���
        % ���ԣ����������ܺ� METRIC��Ȼ������ĸ������Ӧ�ȣ�ֻҪ��ȥ����ǹ��׵㵽��������Ĳο���ľ��뼴��
        Noncontributing = true(1,N);
        Noncontributing(rank(1,:)) = false;  % ��ο��������Population�ĵ�Ϊ���׵�
        METRIC   = sum(dis(1,:)) + sum(Convergence(Noncontributing)); % ԭ���ĵ� IGD-NS(X,Y)
        fitness  = inf(1,N);
        fitness(Noncontributing) = METRIC - Convergence(Noncontributing);
        % Calculate the fitness of contributing solutions
        for p = find(~Noncontributing)            % ���׵������
            temp = rank(1,:) == p;                % �빱�׵�p����Ĳο���Ϊ1������Ϊ0
            noncontributing = false(1,N);         % 
            noncontributing(rank(2,temp)) = true; % �빱�׵�p����Ĳο��㣬��˲ο���ڶ����ĵ�Ϊ��(���Ϊ�µĹ��׵�)
            noncontributing = noncontributing & Noncontributing; 
            % Ϊ����ζ�ţ��������ԭ���Ƿǹ��׵㣬������Ϊɾ����p�㣬����˹��׵㣬��ˣ���Ҫ��ȥԭ���Ƿǹ��׵�ʱ�ӵ�
            % �Ǹ��������Ref�ľ��롾sum(Convergence(noncontributing))�������ϱ�ɹ��׵�ʱ��
            % ��Ӧ��Ref���˵�ľ��롾sum(dis(2,temp))�����ټ�ȥɾȥ��Ϊp�������ӵ�����sum(dis(1,temp))����
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