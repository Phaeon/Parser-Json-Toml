#include <iostream>
#include "booleen.h"
#include "cle.h"
#include "document.h"
#include "driver.hh"
#include "element.h"
#include "ligne.h"
#include "nombre.h"
#include "tableau.h"
#include "texte.h"
#include "valeur.h"

using namespace std;
using namespace common;

int main()
{
    Texte * t = new Texte("test");
    Cle *cle = new Cle(t);
    Booleen *b = new Booleen(b);
    Document *doc = new Document();
    Valeur *val = new Valeur();
    Ligne *ligne = new Ligne(cle, val);
    Nombre *nbr = new Nombre();
    Tableau *tab = new Tableau();

}
