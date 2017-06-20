function scores = vrp_fitness(x,demands,distances)
%VRP_FITNESS  Custom fitness function for VRP, based on the split algorithm.
%   SCORES = TRAVELING_SALESMAN_FITNESS(X,DISTANCES) Calculate the fitness
%   of an individual. The fitness is the total distance traveled for an
%   ordered set of cities in X. DISTANCE(A,B) is the distance from the city
%   A to the city B.

scores = zeros(size(x,1),1);
for k = 1:size(x,1)
    % here is where the special knowledge that the population is a cell
    % array is used. Normally, this would be pop(j,:);
    S = x{k};
    
    W = 550; %车辆容量
    n = length(S); %
    V = Inf(1,n+1); % V的检索需要将节点编号加1
    V(1) = 0;
    for i = 1:n
        load = 0;
        cost = 0;
        for j = i:n
            % 计算单条线路的总载重量，不能超过车辆容量
            load = load + demands(S(j)+1);
            if load > W
                break;
            end
            if i == j
                cost = distances(1,S(j)+1)*2;
            else
                cost=cost-distances(1,S(j-1)+1)+distances(S(j-1)+1,S(j)+1)+distances(1,S(j)+1);
            end
            if (V(i) + cost) < V(j+1)
                V(j+1) = V(i) + cost;
            end
        end
    end
    scores(k) = V(n+1);
end