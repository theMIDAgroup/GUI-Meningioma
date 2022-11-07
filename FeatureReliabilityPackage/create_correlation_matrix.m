function  M = create_correlation_matrix(type)
if strcmp(type,'consistency')
    M1_lower = diag(ones(10,1))...
        +diag(1*ones(9,1),-1)+diag(0*ones(8,1),-2)+diag(0*ones(7,1),-3)+diag(0*ones(6,1),-4)+...
        +diag(0*ones(5,1),-5)+diag(0*ones(4,1),-6)+diag(0*ones(3,1),-7)+diag(0*ones(2,1),-8)...
        +diag(0*ones(1,1),-9);

    M1_upper = diag(1*ones(9,1),-1)+diag(0*ones(8,1),-2)+diag(0*ones(7,1),-3)+diag(0*ones(6,1),-4)+...
        +diag(0*ones(5,1),-5)+diag(0*ones(4,1),-6)+diag(0*ones(3,1),-7)+diag(0*ones(2,1),-8)...
        +diag(0*ones(1,1),-9);

    M = M1_lower+M1_upper';

    M(10,10)=0;
elseif strcmp(type,'robustness')
    M = zeros(10,10);
    M(10,:)=1;
    M(9,:)=1;
    M(8,:)=1;
    M(1:7,:)=0;
    M(8:10,9:10)=0;
    M(9,8)=0;
    M(8,7:8)=0;

elseif strcmp(type,'instability')
    M = zeros(10,10);
    M(:,8:10) = 1;
    M(1:2,8:10) = 0;
    M = flip(M);
    M(10,10) = 0;
    M(8,8:9) = 0;
    M(7,8) = 0;
    
elseif strcmp(type,'quality')
    M = zeros(10,10);
    M(10,10) = 1;
end

end