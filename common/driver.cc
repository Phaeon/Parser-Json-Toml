#include "driver.hh"

common::driver::driver() {
    racine = new Document;

}

common::Document *common::driver::get_racine() {
    return racine;
}

common::Objet* common::driver::getObjetCourant() {

    // Dans le cas où l'objet principal n'a été instancié
    if (static_cast<Valeur*>((get_racine()->getElements().front())) == nullptr) {
           Objet* temp = new Objet();

           get_racine()->ajoutElementFin(new Valeur(temp));
           setObjetCourant(temp);
           return temp;
    }

    if (_o == nullptr) {
        _o = new Objet();
    }

    return _o;

}

void common::driver::setObjetCourant(Objet* o) {
    _o = o;
}


common::Objet* common::driver::getTableCourant() {

    if (_table == nullptr) {
        _table = new Objet();
    }

    return _table;

}

void common::driver::setTableCourant(Objet* o) {
    _table = o;
}

common::Cle* common::driver::getCleTable() {
    if (_cleTable == nullptr) {
        return nullptr;
    }
    return _cleTable;
}

void common::driver::setCleTable(Cle* cle) {
    _cleTable = cle;
}

common::Objet* common::driver::getMainObject() {
    getObjetCourant();
    return static_cast<Objet*>((get_racine()->getElements().front())->getElements().front());
}
