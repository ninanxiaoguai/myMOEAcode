clc,clear
global N M D  PopCon name Range REF

N = 100;                        % ��Ⱥ����
D = 10;                         % ��������
M = 3;                          % Ŀ�����
name = 'DTLZ3';                 % ���Ժ���ѡ��Ŀǰֻ�У�DTLZ1��DTLZ2��DTLZ3
REF = UniformPoint(N,M);        % ����һ���Բο���
[res,Population,PF] = funfun(); % ���ɳ�ʼ��Ⱥ��Ŀ��ֵ
plot3(REF(:,1),REF(:,2),REF(:,3),'ko')
hold on
plot3(res(:,1),res(:,2),res(:,3),'g*')
for i = 1:size(REF,1)
    hold on
    plot3([0,2*REF(i,1)],[0,2*REF(i,2)],[0,2*REF(i,3)],'b-')
end
[Archive,RefPoint,Range] = UpdateRefPoint(res,REF,[]);
% hold on
% plot3(Archive(:,1),Archive(:,2),Archive(:,3),'g*')
% hold on
% plot3(RefPoint(:,1),RefPoint(:,2),RefPoint(:,3),'b^')
%while Global.NotTermination(Population)
PD_v = [];
for i = 1:400
    MatingPool = MatingSelection(Population,RefPoint,Range);  %���޸�
    Offspring  = GA(Population(MatingPool,:));                %���޸�
    Offspring_objs = CalObj(Offspring);
    [Archive,RefPoint,Range] = UpdateRefPoint([Archive;Offspring_objs([all(PopCon<=0,2)],:)],REF,Range);
    [Population,Range]       = EnvironmentalSelection([Population;Offspring],RefPoint,Range,N);
    %----------��ʾ��----------
    Popobj = CalObj(Population);
    %PD_v(i) = PD(Popobj);
    plot3(Popobj(:,1),Popobj(:,2),Popobj(:,3),'ro')
    hold on
    plot3(RefPoint(:,1),RefPoint(:,2),RefPoint(:,3),'bo')
    title(num2str(i));
%     for ii = 1:size(REF,1)
%         hold on
%         plot3([0,(Range(2,1)-Range(1,1))*2*REF(ii,1)],[0,(Range(2,2)-Range(1,2))*2*REF(ii,2)],[0,(Range(2,3)-Range(1,3))*2*REF(ii,3)])
%     end
    hold off
%     plot(1:i,PD_v,'ro');
    drawnow
end
hold on
plot3(PF(:,1),PF(:,2),PF(:,3),'g*')
