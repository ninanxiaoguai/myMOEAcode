function [Archive,RefPoint,Range] = UpdateRefPoint(Archive,W,Range)
	%% Delete duplicated and dominated solutions
    Archive = unique(Archive(NDSort(Archive,1)==1,:),'rows');
    NA      = size(Archive,1);
    NW      = size(W,1);
    
	%% Update the ideal point
    if ~isempty(Range)
        Range(1,:) = min([Range(1,:);Archive],[],1);
    elseif ~isempty(Archive)
        Range = [min(Archive,[],1);max(Archive,[],1)];
    end
    
    %% Update archive and reference points
    if size(Archive,1) <= 1
        RefPoint = W;
    else
        %% Find contributing solutions and valid weight vectors
        tArchive = Archive - repmat(Range(1,:),NA,1);
        W        = W.*repmat(Range(2,:)-Range(1,:),NW,1); % W 为原论文中的R 进行放缩到与W同一范围内
        Distance      = CalDistance(tArchive,W);          % 使tAchieve在周围的射线上都有相应的RefPoint
        [~,nearestP]  = min(Distance,[],1);
        ContributingS = unique(nearestP);                 % 离每一个ref最近的Archive中的点的索引，原论文中的 A^con 
        [~,nearestW]  = min(Distance,[],2);               % 离每一个Archive最近的ref中的点的索引
        ValidW        = unique(nearestW(ContributingS)) ; % 离每一个Archive^con最近的ref中的点的索引,原论文中的R^valid

        %% Update archive
        Choose = ismember(1:NA,ContributingS);            % 把A^con 在A中的对应位置设为1     
        Cosine = 1 - pdist2(tArchive,tArchive,'cosine');  % 计算A^con之间的彼此cos距离
        Cosine(logical(eye(size(Cosine,1)))) = 0;         % 使对角线上的值为0
        while sum(Choose) < min(3*NW,size(tArchive,1))
            unSelected = find(~Choose);                   % 未被选择的的解 即原论文中的 A\A'
            [~,x]      = min(max(Cosine(~Choose,Choose),[],2)); % arccos 与 cos 关于 角度的关系相反，因此在原论文中 max(min()) 
            Choose(unSelected(x)) = true;                       % 在这里就要min(max())
        end
        Archive  = Archive(Choose,:);
        tArchive = tArchive(Choose,:);

        %% Update reference points
        RefPoint = [W(ValidW,:);tArchive];            % 选择出R^valid 的来源是 A'\R' 所以要把tAchieve与选出来的W放在一起
        Choose   = [true(1,length(ValidW)),false(1,size(tArchive,1))];
        Cosine   = 1 - pdist2(RefPoint,RefPoint,'cosine');
        Cosine(logical(eye(size(Cosine,1)))) = 0;
        while sum(Choose) < min(NW,size(RefPoint,1))
            Selected = find(~Choose);
            [~,x]    = min(max(Cosine(~Choose,Choose),[],2));
            Choose(Selected(x)) = true;
        end
        RefPoint = RefPoint(Choose,:);
    end 
end