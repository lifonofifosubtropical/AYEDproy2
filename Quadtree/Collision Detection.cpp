#include <iostream>
#include <math.h>
using namespace std;

class nodo{
public:
        int Px,Py;
        nodo *sig,*ant;  
};
      
class lista{
	public:
		nodo *head;
		nodo *ultimo;
		int tamano;
	public:
		lista();	
		bool vacio();
		void addNodo(int,int);
		void desenlazar(nodo*);
		void encolar(nodo*);
		~lista();		
};

lista::lista(){
                
    head=NULL;
    ultimo=NULL;
    tamano=0;
}

bool lista::vacio(){
     
    return(head==NULL);
}
     
void lista::addNodo(int px,int py){
 
	nodo *nuevo= new nodo;
	nuevo->Px= px;
	nuevo->Py= py;

	nuevo->sig=NULL;
     
    if(vacio()){
        head=nuevo;
        ultimo=nuevo;
        nuevo->ant=NULL;
    }else{              
        ultimo->sig =nuevo;
        nuevo->ant= ultimo;
        ultimo=nuevo;
    }
    tamano++;
}

void lista::encolar(nodo*nuevo){

	nuevo->sig=NULL;
     
    if(vacio()){
        head=nuevo;
        ultimo=nuevo;
        nuevo->ant=NULL;
    }else{     

        ultimo->sig= nuevo;
        nuevo->ant= ultimo;
        ultimo=nuevo;
    }

    tamano++;
}

void lista::desenlazar(nodo*p){
	if (tamano==1)
	{
		head=NULL;
		ultimo=NULL;

	}else if (p->sig!=NULL && p!=head)
	{
		nodo *n = p->ant;
		n->sig = p->sig;	

	}else if (p==head)
	{
		head=p->sig;
	}

	p->sig=NULL;
	p->ant=NULL;

	tamano--;	
}

lista::~lista(){
	
    nodo *posi=head;
    nodo *ant=head;
    
    while(posi!=NULL){
    	ant=posi;
    	posi=posi->sig;
    	delete ant;
    	ant=posi;
    }
}

class ArbNode{
	public:

	int xsd,ysd,xii,yii,nivel;

	lista objeto; 

	ArbNode	*I,*II,*III,*IV;
};

class QT{
	public:
		ArbNode *raiz;
		int maxO,maxS,radio;
		QT(int,int,int,int,int, lista&);
		void divisor(ArbNode*);
		bool colision(nodo*, nodo*);
		bool intersecta(nodo*, ArbNode*, ArbNode*);
		void preorden(ArbNode*);
};

QT::QT(int tamano,int objetos,int rad,int maxObj,int maxSub, lista &circulos){
	ArbNode *nuevo= new ArbNode;
	nuevo->xsd=nuevo->ysd=tamano;
	nuevo->xii=nuevo->yii=0;
	nuevo->objeto= circulos;
	nuevo->I=nuevo->II=nuevo->III=nuevo->IV=NULL;
	nuevo->nivel=0;

	raiz=nuevo;
	maxO=maxObj;
	maxS=maxSub;
	radio=rad;
	divisor(raiz);
	preorden(raiz);
}

void QT::divisor(ArbNode *nodop){

	if (nodop->nivel!=maxS && nodop->objeto.tamano > maxO)
	{
		ArbNode *NI= new ArbNode;

		NI->xsd=((nodop->xsd - nodop->xii) / 2) + nodop->xii;
		NI->ysd= nodop->ysd;
		NI->xii= nodop->xii;
		NI->yii= ((nodop->ysd - nodop->yii) / 2) + nodop->yii;
		NI->I=NI->II=NI->III=NI->IV=NULL;

		ArbNode *NII= new ArbNode;

		NII->xsd= nodop->xsd;
		NII->ysd= nodop->ysd;
		NII->xii= ((nodop->xsd - nodop->xii) / 2) + nodop->xii;
		NII->yii= ((nodop->ysd - nodop->yii) / 2) + nodop->yii;
		NII->I=NII->II=NII->III=NII->IV=NULL;

		ArbNode *NIII= new ArbNode;

		NIII->xsd= ((nodop->xsd - nodop->xii) / 2) + nodop->xii;
		NIII->ysd= ((nodop->ysd - nodop->yii) / 2) + nodop->yii;
		NIII->xii= nodop->xii;
		NIII->yii= nodop->yii;
		NIII->I=NIII->II=NIII->III=NIII->IV=NULL;

		ArbNode *NIV= new ArbNode;

		NIV->xsd= nodop->xsd;
		NIV->xii= ((nodop->xsd - nodop->xii) / 2) + nodop->xii;
		NIV->ysd= ((nodop->ysd - nodop->yii) / 2) + nodop->yii;
		NIV->yii= nodop->yii;
		NIV->I=NIV->II=NIV->III=NIV->IV=NULL;

		NI->nivel=NII->nivel=NIII->nivel=NIV->nivel= nodop->nivel +=1;

		nodop->I=NI;
		nodop->II=NII;
		nodop->III=NIII;
		nodop->IV=NIV;

		nodo *point = nodop->objeto.head;
		
		while(point!=NULL){
			nodo *p=point;
			point= point->sig;

			if (p->Px <= ((nodop->xsd - nodop->xii) / 2) + nodop->xii)
			{
				if (p->Py >= ((nodop->ysd - nodop->yii) / 2) + nodop->yii)
				{
					if (!intersecta(p,NI,nodop))
					{
						nodop->objeto.desenlazar(p);

						NI->objeto.encolar(p);
					}
				}if (p->Py <= ((nodop->ysd - nodop->yii) / 2) + nodop->yii)
				{
					if (!intersecta(p,NIII,nodop))
					{
						nodop->objeto.desenlazar(p);

						NIII->objeto.encolar(p);
					}
				}
			}if (p->Px >= ((nodop->xsd - nodop->xii) / 2) + nodop->xii)
			{

				if (p->Py >= ((nodop->ysd - nodop->yii) / 2) + nodop->yii)
				{
					if (!intersecta(p,NII,nodop))
					{
						nodop->objeto.desenlazar(p);

						NII->objeto.encolar(p);
					}
				}if (p->Py <= ((nodop->ysd - nodop->yii) / 2) + nodop->yii)
				{
					if (!intersecta(p,NIV,nodop))
					{
						nodop->objeto.desenlazar(p);

						NIV->objeto.encolar(p);
					}
				}
			}
		}

		divisor(NI);
		divisor(NII);
		divisor(NIII);
		divisor(NIV);
	}
}

bool QT::colision(nodo* circulo1, nodo* circulo2){

	int x = circulo2->Px - circulo1->Px;
	if (x<0){x*=-1;}
	int y = circulo2->Py - circulo1->Py;
	if (y<0){y*=-1;}

	float distance = sqrt((pow(x,2)+ pow(y,2)));

	return (distance < (radio*2));
}

bool QT::intersecta(nodo *circulo, ArbNode *cuadrante, ArbNode *padre){
	if((((cuadrante->xsd - circulo->Px) < radio) || ((circulo->Px - cuadrante->xii) < radio) || ((circulo->Py - cuadrante->yii) < radio) || ((cuadrante->ysd - circulo->Py) < radio))){	 

	padre->objeto.desenlazar(circulo);
	
	padre->objeto.tamano+=1;
	
	cuadrante->objeto.encolar(circulo);

	cuadrante->objeto.tamano-=1;

	return true;
	}
	return false;
}

int comparaciones=0, cont=0;

int main(){

	int N,M,R,K,L,Xi,Yi;
	cin>>N>>M>>R>>K>>L;

	lista objects;

	for (int i = 0; i < M; ++i)
	{
		cin>>Xi>>Yi;
		objects.addNodo(Xi,Yi);
	}

	QT arbol(N,M,R,K,L,objects);

	int bruta= M*(M-1)/2;
	
	cout<<endl<<comparaciones<<" "<<bruta<<endl<<cont<<endl;

return 0;
}

void QT:: preorden(ArbNode* node){

	if(node!=NULL){

		cout<<node->objeto.tamano<<" ";

		if(node->objeto.head!=NULL && node->objeto.head->sig!=NULL)
		{
			nodo *p=node->objeto.head;
			nodo *p2=node->objeto.head->sig;

			while(p!=NULL){

				while(p2!=NULL)
				{
					comparaciones+=1;

					if(colision(p,p2))
					{
						cont+=1;
					}
					p2=p2->sig;
				}p=p->sig;

				if(p!=NULL && p->sig!=NULL)
				{
					p2=p->sig;
				}
			}
		}
		preorden(node->I);
		preorden(node->II);
		preorden(node->III);
		preorden(node->IV);
	}
}
