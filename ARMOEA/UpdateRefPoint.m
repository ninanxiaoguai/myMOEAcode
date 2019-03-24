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
        W        = W.*repmat(Range(2,:)-Range(1,:),NW,1); % W Ϊԭ�����е�R ���з�������Wͬһ��Χ��
        Distance      = CalDistance(tArchive,W);          % ʹtAchieve����Χ�������϶�����Ӧ��RefPoint
        [~,nearestP]  = min(Distance,[],1);
        ContributingS = unique(nearestP);                 % ��ÿһ��ref�����Archive�еĵ��������ԭ�����е� A^con 
        [~,nearestW]  = min(Distance,[],2);               % ��ÿһ��Archive�����ref�еĵ������
        ValidW        = unique(nearestW(ContributingS)) ; % ��ÿһ��Archive^con�����ref�еĵ������,ԭ�����е�R^valid

        %% Update archive
        Choose = ismember(1:NA,ContributingS);            % ��A^con ��A�еĶ�Ӧλ����Ϊ1     
        Cosine = 1 - pdist2(tArchive,tArchive,'cosine');  % ����A^con֮��ı˴�cos����
        Cosine(logical(eye(size(Cosine,1)))) = 0;         % ʹ�Խ����ϵ�ֵΪ0
        while sum(Choose) < min(3*NW,size(tArchive,1))
            unSelected = find(~Choose);                   % δ��ѡ��ĵĽ� ��ԭ�����е� A\A'
            [~,x]      = min(max(Cosine(~Choose,Choose),[],2)); % arccos �� cos ���� �ǶȵĹ�ϵ�෴�������ԭ������ max(min()) 
            Choose(unSelected(x)) = true;                       % �������Ҫmin(max())
        end
        Archive  = Archive(Choose,:);
        tArchive = tArchive(Choose,:);

        %% Update reference points
        RefPoint = [W(ValidW,:);tArchive];            % ѡ���R^valid ����Դ�� A'\R' ����Ҫ��tAchieve��ѡ������W����һ��
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