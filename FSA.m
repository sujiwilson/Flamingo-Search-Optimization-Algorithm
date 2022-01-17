function [Score,Position,Convergence_curve]=FSA(Pop,Max_iter,lb,ub,dim,fobj)
if size(ub,1)==1
    ub=ones(dim,1)*ub;
    lb=ones(dim,1)*lb;
end
Convergence_curve = zeros(1,Max_iter);
%Initialize the positions 
X=initialization(Pop,dim,ub,lb);
Position=zeros(1,dim);
Score=inf;
%calculate the initial fitness 
for i=1:size(X,1)
    Fitness(1,i)=fobj(X(i,:));
end
[sorted_fitness,sorted_indexes]=sort(Fitness);
for newindex=1:Pop
    Sorted_Pos(newindex,:)=X(sorted_indexes(newindex),:);
end
Position=Sorted_Pos(1,:);
Score=sorted_fitness(1);
%Main loop
l=1;    %initial itreration
while l<Max_iter+1
 MP_b=0.1;                    % The basic proportion of flamingos migration in the first stage.
R=rand();
MPr=round(R*Pop*(1-MP_b));   % The number of flamingos migrating in the second stage.
MPo=MP_b*Pop;         %The number of flamingos that migrate in the first phase.
MPt=Pop-MPo-MPr;      %The number of flamingos foraging for food.
Xb=Sorted_Pos(1,:);

% This function is randomly evaluated between negative 1 and 1.
    a=rand();
    if a>0.5
        eps= 1;
    else
        eps= -1;
    end
 G= random('Normal',0,1);
 
%  The first phase migratory flamingo update function.
    for j=1:round(MPo)
        for i=1:dim
            sz=1; w = normrnd(0,1.2,sz);
            X(j, i) = X(j, i) + (Xb(i) - X(j, i)) * w;   %eqn.3
        end
    end
%  Foraging flamingo position update function.
    for j =1+round(MPo):round(MPo+MPt)
        for i=1:dim
            X(j, i) = (X(j, i) + eps * Xb(i) + G * (G * abs(Xb(i) + eps * X(j, i)))) / chi2pdf(8,1);   %eqn.2
        end
    end
    
    % The second stage migratory flamingo position update function.
    for j =round(MPo+MPt)+1:Pop
        for i=1:dim
            sz=1;w = normrnd(0,1.2,sz);
            X(j, i) = X(j, i)+(Xb(i)-X(j, i))*w;      %eqn.3
        end
    end
    for i=1:Pop
        for j=1:dim
            if X(i,j)<lb(j)
                X(i,j) = ub(j);
            elseif X(i,j)>ub(j)
                X(i,j) = lb(j);
            end
        end
    end
    
    
   for i=1:size(X,1)  
        Fitness(1,i)=fobj(X(i,:));
        
        if Fitness(1,i)<Score
            Position=X(i,:);
            Score=Fitness(1,i);
            
        end
   end
    
    Convergence_curve(l)=Score;
    l = l + 1;
end
