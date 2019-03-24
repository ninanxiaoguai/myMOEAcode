function Distance = CalDistance(PopObj,RefPoint)
% Calculate the distance between each solution to each adjusted reference
% point

    N  = size(PopObj,1);
    NR = size(RefPoint,1);
    PopObj   = max(PopObj,1e-6);
    RefPoint = max(RefPoint,1e-6);
    
    %% Adjust the location of each reference point
    Cosine = 1 - pdist2(PopObj,RefPoint,'cosine');
    NormR  = sqrt(sum(RefPoint.^2,2));             % 每一行的平方和再开根号 
    NormP  = sqrt(sum(PopObj.^2,2));
    d1     = repmat(NormP,1,NR).*Cosine;           % P 在 R 上的投影
    d2     = repmat(NormP,1,NR).*sqrt(1-Cosine.^2);% P 到 R 的垂直距离
    [~,nearest] = min(d2,[],1);                    % 把 d2 的每一列排序，nearest是每一列的最小的索引(第几行数)
    plot3(RefPoint(:,1),RefPoint(:,2),RefPoint(:,3),'k*') % 原来的RefPoint
    RefPoint    = RefPoint.*repmat(d1(N.*(0:NR-1)+nearest)'./NormR,1,size(RefPoint,2));
    hold on
    plot3(PopObj(:,1),PopObj(:,2),PopObj(:,3),'go')       % PopObj
    hold on
    plot3(RefPoint(:,1),RefPoint(:,2),RefPoint(:,3),'ro') % 现在的RefPoint
    hold off
    %d1(N.*(0:NR-1)+nearest)' : 把d1变成列向量的形式 
    %% Calculate the distance between each solution to each point
    Distance = pdist2(PopObj,RefPoint);
end
% for ii = 1:91
%         hold on
%         plot3([0,1.5*RefPoint(ii,1)],[0,1.5*RefPoint(ii,2)],[0,1.5*RefPoint(ii,3)],'g-')
% end   