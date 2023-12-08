# encoding: utf8

# YOUR NAME: Rafael Amorim
# YOUR NUMBER: 98197

# COLLEAGUES WITH WHOM YOU DISCUSSED THIS ASSIGNMENT:
# - ...
# - ...

from semantic_network import *
from bayes_net import *
from constraintsearch import *


class MySN(SemanticNetwork):
    def __init__(self):
        SemanticNetwork.__init__(self)
        # ADD CODE HERE IF NEEDED
        pass

    def is_object(self, user, obj):  

        for d in self.declarations:
            if d.user == user:
                if isinstance(d.relation, Association) and d.relation.card == None:
                        if obj == d.relation.entity1 or obj == d.relation.entity2:
                            return True
                if isinstance(d.relation, Member) and d.relation.entity1 == obj:
                        return True
        return False

    def is_type(
        self, user, type
    ):  

        return (
            True
            if type
            in [
                i.relation.entity2
                for i in self.declarations
                if i.user == user
                and isinstance(i.relation, Member)
                or i.user == user
                and isinstance(i.relation, Association)
                and (i.relation.entity1 == type or i.relation.entity2 == type)
                and i.relation.card != None 
            ]
            else False
        )

    def infer_type(self, user, obj): 
        dic = {}

        for i in self.declarations:
            if i.user == user and isinstance(i.relation, Association) and i.relation.card != None :
                # guardamos no dicionario o nome da associação e o tuplo com os tipos das entidades
                dic[i.relation.name] = self.infer_signature(user, i.relation.name)
                
            if i.user == user and isinstance(i.relation, Member) and i.relation.entity1 == obj:
                return i.relation.entity2

        for i in self.declarations:
            if isinstance(i.relation,Association):
                if i.user == user and i.relation.name in dic.keys():
                    if i.relation.entity1 == obj:
                        # devolvemos o tipo da entidade 2
                        return dic[i.relation.name][0]
                    if i.relation.entity2 == obj:
                        # devolvemos o tipo da entidade 1
                        return dic[i.relation.name][1]
                elif i.relation.name not in dic.keys() and (i.relation.entity1 == obj or i.relation.entity2 == obj):
                    return "__unknown__"
        return None

    def infer_signature(self, user, assoc): 
        # para cada declaracao d em self.declarations fazer
        for d in self.declarations:
            # se o nome da relação for iguai ao nome da associação 
            if d.user == user and isinstance(d.relation, Association) and d.relation.name == assoc:
                # se a cardinalidade for diferente de None devolvemos o tuplo
                return (d.relation.entity1, d.relation.entity2) if d.relation.card != None else (self.infer_type(user, d.relation.entity1), self.infer_type(user, d.relation.entity2))
        return None


class MyBN(BayesNet):
    def __init__(self):
        BayesNet.__init__(self)
        

    def markov_blanket(self, var):
        result = set() # para nao haver repetidos
        # para cada chave do dicionario de dependencias fazer
        for key, deps in self.dependencies.items(): 
            # para cada tuplo (mtrue, mfalse, p) na lista de dependencias da chave fazer
            for mtrue, mfalse, p in deps:           
                # atribuir a variaveis o conjunto de variaveis que dependem da chave
                variables = mtrue + mfalse + [key] 
                # se var estiver em variaveis, atualizar variaveis no conjunto result 
                if var in variables:
                    result.update(variables)
                    break
        # remover var do conjunto result
        result.remove(var)
        return list(result)

class MyCS(ConstraintSearch):
    def __init__(self, domains, constraints):
        ConstraintSearch.__init__(self, domains, constraints)

    def propagate(self, domains, var):
        # propagarRestrições(grafoRestrições, FilaArestas retorna o grafo de restrições com dominios possivelmente mais limitados)
        l = [ (v, z) for (v, z) in self.constraints if z == var ]
        # enquanto FilaArestas nao vazia fazer
        while l != []:
            # (i, j) = remover cabeça de FilaArestas
            (i, j) = l.pop()
            # remover valores inconsistentes de i
            c = self.constraints[i, j]
            nValores = len(domains[i])
            domains[i] = [ v_i for v_i in domains[i] if any(c(i, v_i, j, v_j) for v_j in domains[j]) ]
            # Se removeu valores, então
            if  nValores > len(domains[i]):  
                # para cada vizinho w, acrescentar (w, i) na FilaArestas
                l += [ (w, z) for (w, z) in self.constraints if z == i ]

        return domains
    

    def produto_cartesiano(self,dominios, lvars):
        
        if lvars == []:
            return [()]
        rec = self.produto_cartesiano(dominios, lvars[1:])
        v = lvars[0]
        return [(x,)+t for t in rec for x in dominios[v]]

    def higherorder2binary(self,ho_c_vars,unary_c):
        
        tmp_var = ''.join(ho_c_vars)

        self.domains[tmp_var] = [ p for p in self.produto_cartesiano(self.domains, ho_c_vars) if unary_c(p) ]

        for _,var in enumerate(ho_c_vars):
            self.constraints[var, tmp_var] = lambda v,vx,av,avx : vx==avx[ho_c_vars.index(v)]
            self.constraints[tmp_var, var] = lambda av,avx,v,vx : vx==avx[ho_c_vars.index(v)]
            
        return self.constraints
        