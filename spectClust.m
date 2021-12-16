load('G.mat')

H=simplify(G);
A=adjacency(H,'weighted');
A=A+A';
A=A-diag(diag(A));
nodenames=G.Nodes.level;
H=graph(A);
H.Nodes.level=nodenames;
[bins,binsizes] = conncomp(H,'Type','weak');

for i=1:13
    G=rmnode(H,find(bins~=i));
    terrorist=find(G.Nodes.level==1);
    % NETWORK PARAMETERS
    %
    % # of vertices and edges:
    n = numnodes(G); m = numedges(G);
    % If not assigned, set edge weights to ones:
    if ~any(strcmp('Weight', G.Edges.Properties.VariableNames))
    w = ones(m,1);
    disp('Edge weights set to ones.');
    else
    w = G.Edges.Weight;
    end
    % Plot network:
    

    %
    % CLUSTERING PARAMETERS
    %
    % Pick clustering method:
    Cstr = 'a';
    % k = [Default] k-means.
    % Q = QR algorithm.
    % a = Agglomerative clustering (MATLAB/clusterdata).
    % Pick # of clusters:
    Nmax = 2;
    if (Nmax >= n)
    error('# of clusters must be less than the # of vertices.');
    end

    %
    % LAPLACIAN
    %
    % Adjacency matrix:
    A = adjacency(G, 'weighted');
    % Degree vector:
    d = A*ones(n,1);
    % Degree matrix:
    D = spdiags(d, 0, n, n);
    % Laplacian:
    L = D - A;
    % Normalized Laplacian:
    dinv = d; dinv(dinv>0) = 1./d(d>0);
    D2 = spdiags(sqrt(dinv), 0, n, n);
    normL = D2*L*D2;
    % SEDs of the Laplacians
    % (only the smallest Nmax eigenvalues/vectors are needed):
    [Vec, Val] = eigs(normL, Nmax, 'smallestabs');

    %
    % CLUSTERING
    %
    Class = [];
    normVec=normalize(Vec);
    DataRecords = normVec;
    if isempty(Cstr) || Cstr == 'k'
    Class = kmeans(DataRecords, Nmax, 'Replicates', 100);
    elseif Cstr == 'Q'
    Class = QRClustering(A, Nmax, 1);
    elseif Cstr == 'a'
    Class = clusterdata(DataRecords, 'maxclust', Nmax);
    else
    error('Select a valid clustering method.');
    end
    % ID the largest cluster:
    LargestClass = mode(Class);

    %
    % CLUSTER DISPLAY
    
    % Highlight the clusters.
    figure(i);
    h = plot(G,'NodeLabel',{});
    
    tclass=Class(terrorist);
    tclass=tclass(1);
    h=plot(G,'NodeLabel',{},'EdgeColor','k');   
    highlight(h, find(Class==tclass), 'NodeColor', 'red');
    highlight(h, find(Class~=tclass), 'NodeColor', 'blue');
    ts=size(terrorist);
    sts=size(find(Class==tclass));
    text=horzcat('Graph Size: ',string(n),'Terrorist Nodes: ',string(ts(1)),'Suspected Terrorist Nodes: ',string(sts(1)));
    title(strjoin(text,' '));
end