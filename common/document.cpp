#include "document.h"

using namespace common;

Document::~Document() {
    for(auto e : _elements) {
        delete e;
    }
}

void Document::ajoutElementDebut(Element *e) {
    _elements.push_front(e);
}

void Document::ajoutElementFin(Element *e) {
    _elements.push_back(e);
}

std::list<Element*> Document::getElements() {
    return _elements;
}

bool Document::operator==(Document d2) {
    return (compareDocuments(getElements(), d2.getElements()) == 0);
}

int Document::compareDocuments(std::list<Element*> d1, std::list<Element*> d2) {
    if (d1.size() != d2.size()) return -1;

    Objet* o;
    Objet* o2;
    /*
     * Il faut distinguer l'objet de la racine ainsi qu'un objet "valeur"
     *
     */
    if (dynamic_cast<Objet*>(d1.front()) == nullptr) { // Cas pour la racine
        // Dans le cas où l'un des deux fichiers est un fichier JSON ne contenant qu'une valeur
        if (dynamic_cast<Objet*>((d1.front()->getElements().front())) == nullptr || dynamic_cast<Objet*>((d2.front()->getElements().front())) == nullptr) {
            return -1;
        }
        o = static_cast<Objet*>((d1.front()->getElements().front()));
        o2 = static_cast<Objet*>((d2.front()->getElements().front()));
    } else { // Cas pour tout autre objet
        o = static_cast<Objet*>((d1.front()));
        o2 = static_cast<Objet*>((d2.front()));
    }

    // Si les objets n'ont pas la même taille, alors ils sont faux
    if (o->getLignes().size() != o2->getLignes().size()) return -1;

    int nbV(0); // Passe au négatif si un cas d'erreur survient lors de l'analyse des sous-objets.

    for (auto& e : o->getLignes()) {
        unsigned int falseLines = 0;
        for (auto& e2 : o2->getLignes()) {

            // Vérifier si les clés correspondent...
            if (e.first->getNomCle() == e2.first->getNomCle()) {

                // ...si oui, et que les éléments qui suivent sont tous deux des objets, alors renvoyer la fonction pour les sous-objets...
                if (dynamic_cast<Objet*>(e.second->getElements().front()) != nullptr
                        && dynamic_cast<Objet*>(e2.second->getElements().front()) != nullptr) {

                    nbV = compareDocuments(e.second->getElements(), e2.second->getElements());
                    break;

                /* ...ou alors si nous arrivons à des tableaux ou a des valeurs primitives, comparer les textes de ces éléments
                générés par la structure de données et le code */
                } else {
                    if (e.second->toTXT() != e2.second->toTXT()) {
                        return -1;
                    }

                }

            // ...sinon incrémenter le nombre de mauvaises comparaisons par 1.
            } else {
                falseLines++;
            }


        }

        // Cas d'erreur : Si aucune correspondance n'a été trouvée parmis les clés
        if (falseLines == o2->getLignes().size()) return -1;
    }
    return nbV;

}


std::string Document::toTXT() const {
    std::string output;

    output = "<DOCUMENT>\n";

    for(auto &e : _elements) {
        output += e->toTXT() + "\n";
    }

    output += "</DOCUMENT>\n";

    return output;
}
