edgesFile = readcell('edges.csv');
nodeFile=readcell('nodes.csv');

s=edgesFile(:,1);
t=edgesFile(:,2);
w=edgesFile(:,3);
w=cell2mat(w);
EdgeTable = table([s t],w, 'VariableNames',{'EndNodes' 'Weight'});

xbt=nodeFile(1:31405,1);
level=cell2mat(nodeFile(1:31405,2));
name=nodeFile(1:31405,3);
crime1=nodeFile(1:31405,4);
crime2=nodeFile(1:31405,5);
NodeTable = table(xbt,level,name,crime1,crime2,'VariableNames',{'Name' 'level','name','crime1','crime2'});

G=digraph(EdgeTable,NodeTable);

%plot(G)

terrorist=find(G.Nodes.level==1);

h = plot(G,'NodeLabel',{});
highlight(h,terrorist, 'NodeColor','red');

[bins,binsizes] = conncomp(G,'Type','weak');