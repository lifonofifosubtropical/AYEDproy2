#!/usr/bin/env python3

class Vertice:
    def __init__(self, node, desp):
        self.id = node
        self.adyacente = {}
        self.desp = desp

    def __str__(self):
        return "{} adyacente: ".format(str(self.id)) + str([x.id for x in self.adyacente])

    def add_vec(self, vecino, dist, maxpeso):
        self.adyacente[vecino] = (dist, maxpeso)

    def get_ady(self):
        return self.adyacente

    def get_id(self):
        return self.id

    def get_dist(self, vecino):
        return self.adyacente[vecino]

    def get_desp(self):
        return self.desp

class Grafo:
    def __init__(self, vert_dicc = {}):
        self.vert_dicc = vert_dicc
        self.num_vertices = len(self.vert_dicc)

    def __iter__(self):
        return iter(self.vert_dicc.values())

    def add_vertice(self, nodo, desp):
        self.num_vertices += 1
        nuevo_vertice = Vertice(nodo, desp)
        self.vert_dicc[nodo] = nuevo_vertice
        return nuevo_vertice

    def get_vertice(self, n):
        if n in self.vert_dict:
            return self.vert_dict[n]
        else:
            return None

    def add_arista(self, desde, a, dist, maxpeso):
        if desde not in self.vert_dicc:
            raise ValueError("Intentando añadir vértice sin definir cantidad de mercancía a despachar en ese vértice.")
        if a not in self.vert_dicc:
            raise ValueError("Intentando añadir vértice sin definir cantidad de mercancía a despachar en ese vértice.")

        self.vert_dicc[desde].add_vec(self.vert_dicc[a], dist, maxpeso)
        self.vert_dicc[a].add_vec(self.vert_dicc[desde], dist, maxpeso)

    def dijkstra(self, ini, fin, peso_actual):
        assert ini in self.vert_dicc, "No existe vértice inicial."

        visitado = dict.fromkeys(self.vert_dicc.keys(), False)
        dist = dict.fromkeys(self.vert_dicc.keys(), float('inf'))
        dist[ini] = 0
        vertices = list(self.vert_dicc.keys())
        vert_prev = dict.fromkeys(self.vert_dicc.keys())

        while vertices:
            actual = min(vertices, key=lambda x: dist[x])
            vertices.remove(actual)
            if dist[actual] == float('inf'):
                break

            for vecino, data in self.vert_dicc[actual].get_ady().items():
                costo, maxpeso = data
                if maxpeso < peso_actual:
                    continue
                ruta_alt = dist[actual] + costo
                if ruta_alt < dist[vecino.id]:
                    dist[vecino.id] = ruta_alt
                    vert_prev[vecino.id] = actual

        camino = list() 
        actual = fin
        while vert_prev[actual] is not None:
            camino.insert(0, actual)
            actual = vert_prev[actual]
        if camino:
            camino.insert(0, actual)
        return (camino, dist[fin], self.vert_dicc[fin].get_desp())

def deduplicar(lista):
    prev = object()
    for i in lista:
        if i != prev:
            prev = i
            yield i

def main():
    numc = int(input())
    for c in range(numc):
        graf = Grafo()
        peso_camion = 0
        recorrido = list()
        dist_total = 0

        while True:
            r = input()
            rr = r.split(" ")
            if len(rr) != 2:
                break
            else:
                P = int(rr[0])
                C = int(rr[1])
                peso_camion += C
                graf.add_vertice(P, C)
                
        O = int(rr[0])
        F = int(rr[1])
        T = int(rr[2])
        P = int(rr[3])
        graf.add_arista(O, F, T, P)

        while True:
            r = input()
            rr = r.split(" ")
            if len(rr) != 4:
                break
            else:
                O = int(rr[0])
                F = int(rr[1])
                T = int(rr[2])
                P = int(rr[3])
                graf.add_arista(O, F, T, P)

        I = int(rr[0])

        for i in list(graf.vert_dicc.keys()):
            aux_list, aux_dist, aux_peso = graf.dijkstra(I, i, peso_camion)
            recorrido.extend(aux_list)
            dist_total += aux_dist
            peso_camion -= aux_peso
            if recorrido:
                I = recorrido[-1]

        print("Caso " + str(c+1) + ":")
        print(*list(deduplicar(recorrido)))
        print(dist_total)
        print()


if __name__ == '__main__':
    main()
