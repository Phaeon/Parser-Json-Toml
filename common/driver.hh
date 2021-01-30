#ifndef DRIVER_H
#define DRIVER_H

#include "document.h"

#include <iostream>
#include <map>

namespace common {

    class driver {
    private:
        Document* racine;
        Objet* _o;
        Objet* _table;
        Cle* _cleTable;
    public:
        driver();

        Document& getDocument();
        void setDocument(const Document& doc);

        Objet* getObjetCourant();
        void setObjetCourant(Objet* o);

        Objet* getTableCourant();
        void setTableCourant(Objet* o);

        Cle* getCleTable();
        void setCleTable(Cle* cle);

        Objet* getMainObject();

        Document* get_racine();
    };
}

#endif
