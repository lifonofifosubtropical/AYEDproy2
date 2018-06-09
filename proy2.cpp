#include <stdio.h>
#include <string.h>

/*
* clase con doble proposito: servir de lista y de cola. En ella 
* se implementan las primitivas de ambas estructuras de datos
*/
template <class T>
class TDA 
{
    private:

        int n;

        struct Nodo
        {
            T dato;
            Nodo *prox;
            
            Nodo(T info) : dato(info), prox(NULL) {}
        };

        Nodo *primero, *ultimo;

    public:

        TDA()
        {
            primero = ultimo = NULL;
            n = 0;
        }

        bool es_vacia() { return !n; };
        
        int tam() { return n; }

        void add(T dato)                    // añade nodo al final de la estructura
        {
            Nodo *nuevo = new Nodo(dato);
            
            if(!n) 
            {
                primero = ultimo = nuevo;
            } else {
                ultimo->prox = nuevo;
                ultimo = ultimo->prox;
            }

            n++;
        }

        T pop()                             // elimina el nodo al principio de la
        {                                   // estructura y retorna su dato
            Nodo *naux = primero->prox;
            
            T aux = primero->dato;
            delete primero;
            primero = naux;
            n--;
            return aux;
        }

        ~TDA()
        {
            for(int i = 0; i < n; i++)
                pop();
        }
};

// variables globales
TDA<int> *lista_ady;
int a, b, m, n, p, q, query;
int *distancia;
char *visitados;

void BFS(int pos)                          // Busqueda en anchura (BFS)
{                                          // consiste en iterar sobre cada
    TDA<int> queue;                        // "nivel" de un grafo, de acuerdo 
                                           // a la distancia desde el nodo
    queue.add(pos);                        // pasado por parametro
    distancia[pos] = 0;

    while(!queue.es_vacia())
    {
        int a = queue.pop();
        visitados[a] = 1;
        int num_vecinos = lista_ady[a].tam();

        while(num_vecinos--)
        {
            int aux = lista_ady[a].pop();

            if(!visitados[aux])
            {
                queue.add(aux);
                distancia[aux] = distancia[a] + 1; // en el arreglo distancia
                visitados[aux] = 1;                // se almacenan todos los 
            }                                      // resultados
        }
    }
}

int main()
{
    // inicializacion de variables
    scanf("%d%d%d", &n, &m, &p);
    
    lista_ady = new TDA<int> [n];
    visitados = new char [n] ();                // inicializa cada elemento en 0
    distancia = new int [n];

    memset(distancia, -1, n * sizeof(int));     // inicializa cada elemento en -1

    while(m--)
    {
        scanf("%d%d", &a, &b);                  // inicializa lista de adyacencia
        lista_ady[a].add(b);
        lista_ady[b].add(a);
    }

    BFS(p);                                     // cuando termine de ejecutarse el 
                                                // arreglo distancia contendra la
    scanf("%d", &q);                            // respuesta de 

    while(q--)
    {
        scanf("%d", &query);
        
        int qt = distancia[query]; 
        
        if(qt >= 0)
        {
            printf("%d\n", qt);
        } else {
            printf("Open your eyes\n");
        }
    }

    delete[] lista_ady;
    delete[] visitados;
    delete[] distancia;
    return 0;
}