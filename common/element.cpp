#include "element.h"

using namespace common;

Element::~Element() {
    for(auto e : _fils) {
        delete e;
    }
}

void Element::ajoutFilsDebut(Element *e) {
    _fils.push_front(e);
}

void Element::ajoutFilsFin(Element *e) {
    _fils.push_back(e);
}

std::list<Element*> Element::getElements() {
    return _fils;
}
