function Distance = CalDistance(PopObj,RefPoint)
% Calculate the distance between each solution to each adjusted reference
% point

    N  = size(PopObj,1);
    NR = size(RefPoint,1);
    PopObj   = max(PopObj,1e-6);
    RefPoint = max(RefPoint,1e-6);
    
    %% Adjust the location of each reference point
    Cosine = 1 - pdist2(PopObj,RefPoint,'cosine');
    NormR  = sqrt(sum(RefPoint.^2,2));             % ÿһ�е�ƽ�����ٿ����� 
    NormP  = sqrt(sum(PopObj.^2,2));
    d1     = repmat(NormP,1,NR).*Cosine;           % P �� R �ϵ�ͶӰ
    d2     = repmat(NormP,1,NR).*sqrt(1-Cosine.^2);% P �� R �Ĵ�ֱ����
    [~,nearest] = min(d2,[],1);                    % �� d2 ��ÿһ������nearest��ÿһ�е���С������(�ڼ�����)
    plot3(RefPoint(:,1),RefPoint(:,2),RefPoint(:,3),'k*') % ԭ����RefPoint
    RefPoint    = RefPoint.*repmat(d1(N.*(0:NR-1)+nearest)'./NormR,1,size(RefPoint,2));
    hold on
    plot3(PopObj(:,1),PopObj(:,2),PopObj(:,3),'go')       % PopObj
    hold on
    plot3(RefPoint(:,1),RefPoint(:,2),RefPoint(:,3),'ro') % ���ڵ�RefPoint
    hold off
    %d1(N.*(0:NR-1)+nearest)' : ��d1�������������ʽ 
    %% Calculate the distance between each solution to each point
    Distance = pdist2(PopObj,RefPoint);
end
% for ii = 1:91
%         hold on
%         plot3([0,1.5*RefPoint(ii,1)],[0,1.5*RefPoint(ii,2)],[0,1.5*RefPoint(ii,3)],'g-')
% end   