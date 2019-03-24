function [PopObj,PopDec] = PROBLEM()

global M D lower upper encoding N
    
    
    %% Generate initial population

    %% Repair infeasible solutions
    function PopDec = CalDec(obj,PopDec)
    end
    %% Calculate objective values
    function PopObj = CalObj(obj,PopDec)
    PopObj(:,1) = PopDec(:,1)   + sum(PopDec(:,2:end),2);
    PopObj(:,2) = 1-PopDec(:,1) + sum(PopDec(:,2:end),2);
    end

    %% Sample reference points on Pareto front
    function P = PF(obj,N)
    P = ones(1,obj.Global.M);
    end
    
end