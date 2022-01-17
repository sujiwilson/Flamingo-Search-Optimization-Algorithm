
%%% Matlab code for FSA created by sujiwilson (mail id: ssuji1414@gmail.com) 
clear all 
clc
N=30; 
Fun_name='F15';  
Max_iterations=100; 
[lowerbound,upperbound,dimension,fitness]=fun_info(Fun_name);
[Best_score,Best_pos,FSA_curve]=FSA(N,Max_iterations,lowerbound,upperbound,dimension,fitness);

figure;
plot(FSA_curve,'-b','linewidth',2);