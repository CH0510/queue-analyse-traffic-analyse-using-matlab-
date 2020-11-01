clear;clc
N=2000;  %用户数
H = 10;    %平均服务时间
lamda=0; %泊松到达过程的参数,到达速率
mu=1/H; %指数分布的参数
C=5;   %信道数
for i=1:1:C %channel记录接入的呼叫的离开时间
    leave(i)=0;
end
%%%%%%%%%%%%%%%以话务量为变量进行呼叫过程阻塞概率的仿真%%%%%%%%%%%%%%%%%%%%%%
for k=1:N
    lamda=lamda+0.01;
    for i=1:1:C
        leave(i)=0;
    end

    %产生服从 Poisson到达过程的用户到达时间
    arrive = exprnd(1/lamda,1,N);
    arrive(:) = cumsum(arrive(:));

    %产生服从指数分布的用户服务时间
    service = exprnd(1/mu,1,N);
     %产生用户离开时间
     for i=1:1:N
         depart(i)=arrive(i)+service(i);
     end
     %计算阻塞概率
     n=0; %被阻塞的用户数
     for i=1:1:N
         flag=0; %标志信道是否被阻塞
         for j=1: 1: C
         if leave(j) < arrive(i) %若果第i个用户到达的时间小于某一个用户在j个信道中离开的时间,则说明该信道空闲,可接入第i个用户
             leave(j)= depart(i); %则此时第j个信道中用户离开时间记为papart(i)
             flag=1;
             break;
         end
         end
         if flag==0 %阻塞
             n=n+1;
         end
     end
    LOSS(k)=n/N;
end
lamda_temp=0.01:0.01:N*0.01;
A= lamda_temp*H; %呼叫强度*保持时间=业务量
plot(A,LOSS,'y') %绘制呼损率的图形
hold on;

%计算阻塞概率的理论值
A=lamda_temp*H;
for j=1:length(A)
    sum=0.0;
    for i=1:1:C
        temp=(A(j)^i)/factorial(i);
        sum= sum+temp;
    end
    Pr(j)=(A(j)^C)/(factorial(C)*sum); %呼损率公式
end

plot(A, Pr, 'r')
title(['呼叫过程拥塞概率的仿真结果,平均服务时间：',num2str(H)]);
xlabel('话务量( Elang)');
ylabel('拥塞概率');
legend('仿真曲线','理论曲线');
grid on;