%load(G.mat)

[bins,binsizes] = conncomp(G,'Type','weak');

IDs=[];
ODs=[];
PRs=[];
ICs=[];
OCs=[];
BTs=[];
for i = 1:13
   H=rmnode(G,find(bins~=i));
   terrorist=find(H.Nodes.level==1);
   order=[terrorist;find(H.Nodes.level==2)];
   H=reordernodes(H,order);
   terrorist=find(H.Nodes.level==1);
   
   id=centrality(H,'indegree','Importance',H.Edges.Weight);
   od=centrality(H,'outdegree','Importance',H.Edges.Weight);
   p=centrality(H,'pagerank','Importance',H.Edges.Weight);
   ic=centrality(H,'incloseness');
   oc=centrality(H,'outcloseness');
   b=centrality(H,'betweenness');
   
   varnames={'XBT Address','Terrorist','InDegree','OutDegree','PageRank','InCloseness','OutCloseness','Betweenness'};

   s=size(H.Nodes.Name);
   ts=size(terrorist);
   o=ones(ts(1),1);
   z=zeros((s(1)-ts(1)),1);
   
   t=table(H.Nodes.Name,[o;z],id,od,p,ic,oc,b,'VariableNames',varnames);
   
   Class = kmeans(table2array(t(:,3:8)), 2, 'Replicates', 100);
   t=[t array2table(Class)];
   tclass=table2array(t(1,9));
   
   figure(i);
   h=plot(H,'NodeLabel',{},'EdgeColor','k');   
   highlight(h, find(Class==tclass), 'NodeColor', 'red');
   highlight(h, find(Class~=tclass), 'NodeColor', 'blue');
   highlight(h, terrorist, 'NodeColor','g','MarkerSize',7);
   safe=size(find(Class~=tclass));
   bad=size(find(Class==tclass));
   text=horzcat('Graph Size: ',string(s(1)),'Terrorist Nodes: ',string(ts(1)),'Suspected Terrorist Nodes: ',string(bad(1)));
   title(strjoin(text,' '));
end
