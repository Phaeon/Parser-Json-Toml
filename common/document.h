#ifndef DOCUMENT_H
#define DOCUMENT_H

#include <list>
#include <map>


#include "element.h"
#include "cle.h"
#include "objet.h"
#include "tableau.h"

namespace common {

class Document {
public:
    Document()=default;
    virtual ~Document();

    void ajoutElementDebut(Element *e);
    void ajoutElementFin(Element *e);

    std::list<Element*> getElements();

    std::string toTXT() const;

    // Surcharge l'opérateur == en étudiant les ensembles d'éléments de chaque format
    bool operator==(Document d2);

    /*
     * Nom: compareDocuments
     *
     * But: Fonction récursive qui va analyser chaque paire Clé/Valeur de chaque document.
     * Retourne: 0 si les fichiers sont identiques, -1 dans le cas contraire.
     *
     **/
    int compareDocuments(std::list<Element*> d1, std::list<Element*> d2);

private:
    std::list<Element*> _elements;
};


}

#endif

