%load('G.mat')

filename='results.xlsx';

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
   tid=id(terrorist);
   od=centrality(H,'outdegree','Importance',H.Edges.Weight);
   tod=id(terrorist);
   p=centrality(H,'pagerank','Importance',H.Edges.Weight);
   tp=id(terrorist);
   ic=centrality(H,'incloseness');
   tic=id(terrorist);
   oc=centrality(H,'outcloseness');
   toc=id(terrorist);
   b=centrality(H,'betweenness');
   tb=id(terrorist);
   
   varnames={'XBT Address','Terrorist','InDegree','OutDegree','PageRank','InCloseness','OutCloseness','Betweenness'};
   q=size(terrorist);
   tt=table(H.Nodes.Name(terrorist),ones(q(1),1),id(terrorist),od(terrorist),p(terrorist),ic(terrorist),oc(terrorist),b(terrorist),'VariableNames',varnames);
   
   %id(terrorist)=[];
   %od(terrorist)=[];
   %p(terrorist)=[];
   %ic(terrorist)=[];
   %oc(terrorist)=[];
   %b(terrorist)=[];
   [~,ID]=maxk(id,10);
   [~,OD]=maxk(od,10);
   [~,PR]=maxk(p,10);
   [~,IC]=maxk(ic,10);
   [~,OC]=maxk(oc,10);
   [~,BT]=maxk(b,10);
   important=unique([ID;OD;PR;IC;OC;BT]);
   q=size(important);
   test=table(H.Nodes.Name(ID),id(ID),od(ID));
   t=table(H.Nodes.Name(important),zeros(q(1),1),id(important),od(important),p(important),ic(important),oc(important),b(important),'VariableNames',varnames);
   t=[tt;t];
   
   A=table2array(t(:,3:8));
   idm=max(A(:,1));
   odm=max(A(:,2));
   prm=max(A(:,3));
   icm=max(A(:,4));
   ocm=max(A(:,5));
   btm=max(A(:,6));
   importance=A(:,1)/idm+A(:,2)/odm+A(:,3)/prm+A(:,4)/icm+A(:,5)/ocm+A(:,6)/btm;
   importance=10*importance/max(importance);
   t=[t table(importance)];
   writetable(t,filename,'Sheet',i);
end

