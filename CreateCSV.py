import requests
import methods
import numpy as np
import time

#f=open('nnodes.csv','w+')
#f.close()
#f=open('nedges.csv','w+')
#f.close()

nodes=np.array([])
edges=np.array([])

with open('testXBTAddr.csv') as file:
    num=0
    bads=[]
    for line in file:
        nodes=np.append(nodes,line[:-1])
        addr=line.split(',')[0]
        bads.append(addr)
        num+=1
        print(num,':',addr)
        time.sleep(5)
        r = requests.get('https://blockchain.info/rawaddr/'+addr)
        transactions=r.json()
        c=0
        for transaction in transactions['txs']:
            c+=1
            print('\tTransaction Number:',c)
            ins=transaction['inputs']
            outs=transaction['out']
            inputs=[]
            i=0
            for input in ins:
                i+=1
                addr=input['prev_out']['addr']
                if not addr in bads:
                    nodes=np.append(nodes,addr+',2')
                inputs.append((addr,methods.adjustValue(str(input['prev_out']['value']))))
            print('\t\tInput:',i)
            outputs=[]
            o=0
            totalBTC=0
            for output in outs:
                o+=1
                try:
                    addr=output['addr']
                except:
                    continue
                if not addr in bads:
                    nodes=np.append(nodes,addr+',2')
                outputs.append((addr,methods.adjustValue(str(output['value']))))
                totalBTC+=methods.adjustValue(str(output['value']))
            print('\t\tOutput:',o)
            
            for input in inputs:
                for output in outputs:
                    weight=input[1]*output[1]/totalBTC
                    edge=str(input[0]+','+output[0]+','+str(weight))
                    edges=np.append(edges,edge)

            with open('nedges.csv','a') as f:
                np.savetxt(f,edges,fmt='%s',delimiter='\n')
                edges=np.array([])
        with open('nnodes.csv','a') as f:
            nodes=np.unique(nodes)
            np.savetxt(f,nodes,fmt='%s',delimiter='\n')
            nodes=np.array([])
