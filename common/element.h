#ifndef ELEMENT_H
#define ELEMENT_H

#include <iostream>
#include <list>

namespace common {

class Element
{
public:
    Element() = default;
    virtual ~Element();

    virtual std::string toTXT() const=0;

    void ajoutFilsDebut(Element *e);
    void ajoutFilsFin(Element *e);

    std::list<Element*> getElements();

protected:
    std::list<Element*> _fils;
};

}

#endif // ELEMENT_H
