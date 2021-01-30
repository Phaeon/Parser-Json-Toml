cmake_minimum_required(VERSION 3.13.4)
project(common)


add_library(common
        driver.cc
        driver.hh
        document.cpp
        document.h
        element.cpp
        element.h
        texte.cpp
        texte.h
        nombre.cpp
        nombre.h
        cle.cpp
        cle.h
        valeur.cpp
        valeur.h
        tableau.cpp
        tableau.h
        booleen.cpp
        booleen.h
        objet.cpp
        objet.h)
