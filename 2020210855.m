clear;clc
N=2000;  %�û���
H = 10;    %ƽ������ʱ��
lamda=0; %���ɵ�����̵Ĳ���,��������
mu=1/H; %ָ���ֲ��Ĳ���
C=5;   %�ŵ���
for i=1:1:C %channel��¼����ĺ��е��뿪ʱ��
    leave(i)=0;
end
%%%%%%%%%%%%%%%�Ի�����Ϊ�������к��й����������ʵķ���%%%%%%%%%%%%%%%%%%%%%%
for k=1:N
    lamda=lamda+0.01;
    for i=1:1:C
        leave(i)=0;
    end

    %�������� Poisson������̵��û�����ʱ��
    arrive = exprnd(1/lamda,1,N);
    arrive(:) = cumsum(arrive(:));

    %��������ָ���ֲ����û�����ʱ��
    service = exprnd(1/mu,1,N);
     %�����û��뿪ʱ��
     for i=1:1:N
         depart(i)=arrive(i)+service(i);
     end
     %������������
     n=0; %���������û���
     for i=1:1:N
         flag=0; %��־�ŵ��Ƿ�����
         for j=1: 1: C
         if leave(j) < arrive(i) %������i���û������ʱ��С��ĳһ���û���j���ŵ����뿪��ʱ��,��˵�����ŵ�����,�ɽ����i���û�
             leave(j)= depart(i); %���ʱ��j���ŵ����û��뿪ʱ���Ϊpapart(i)
             flag=1;
             break;
         end
         end
         if flag==0 %����
             n=n+1;
         end
     end
    LOSS(k)=n/N;
end
lamda_temp=0.01:0.01:N*0.01;
A= lamda_temp*H; %����ǿ��*����ʱ��=ҵ����
plot(A,LOSS,'y') %���ƺ����ʵ�ͼ��
hold on;

%�����������ʵ�����ֵ
A=lamda_temp*H;
for j=1:length(A)
    sum=0.0;
    for i=1:1:C
        temp=(A(j)^i)/factorial(i);
        sum= sum+temp;
    end
    Pr(j)=(A(j)^C)/(factorial(C)*sum); %�����ʹ�ʽ
end

plot(A, Pr, 'r')
title(['���й���ӵ�����ʵķ�����,ƽ������ʱ�䣺',num2str(H)]);
xlabel('������( Elang)');
ylabel('ӵ������');
legend('��������','��������');
grid on;