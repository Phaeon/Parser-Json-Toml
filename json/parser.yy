%skeleton "lalr1.cc"
%require "3.2"

%defines
%define api.namespace { json }
%define api.parser.class { parser }
%define api.value.type variant
%define parse.assert
%define parse.trace

%locations

%code requires{

    namespace json {
        class scanner;
    }

    #include "common.hh"
    
}

%parse-param { json::scanner &scanner }
%parse-param { common::driver &driver }

%code{
    #include <iostream>
    #include <map>
    #include <vector>
    #include <string>
    #include <algorithm>
    
    #include "scanner.hh"

    #undef  yylex
    #define yylex scanner.yylex
}

%token                  NL END NUL
%token <int>			ENTIER
%token <float>    		FLOAT
%token <std::string>	TEXTE
%token <bool>			BOOLEAN

%type <common::Objet*> object
%type <std::map<common::Cle*, common::Valeur*> > lignes
%type <std::pair<common::Cle*, common::Valeur*> > ligne
%type <common::Cle*> cle
%type <common::Texte*> texte
%type <common::Valeur*> value
%type <std::vector<common::Valeur*> > avalue
%type <common::Booleen*> booleen
%type <common::Nombre*> nombre
%type <common::Tableau*> array

%%

document:
    json {
        driver.setObjetCourant(nullptr);
        YYACCEPT;
    }
    | END {
        YYACCEPT;
    }
    | error NL document {yyerrok;}
    
json:
	value {
		driver.get_racine()->ajoutElementFin($1);
		driver.setObjetCourant(static_cast<common::Objet*>($1));	
	}
	
object:
	'{' lignes '}' {
		$$ = new common::Objet();
		
		for (std::map<common::Cle*, common::Valeur*>::iterator it = $2.begin(); it != $2.end(); it++) {
			$$->ajoutElement(it->first, it->second);
		}
		
	}
	| '{' '}' {
		$$ = new common::Objet();
	}
    
lignes:
	ligne {
		$$ = std::map<common::Cle*, common::Valeur*>();
		$$.insert($1);
	}
	| ligne ',' lignes {
		$$ = $3; 
        for (auto ele : $$) {
			if (ele.first->getNomCle() == $1.first->getNomCle()){
        		std::cout << "La clé " << $1.first->getNomCle() << " existe déjà." << std::endl;
        		YYABORT;
        	}
        }
		$$.insert($1);
	}
    
ligne:
	cle ':' value {
		$$ = std::pair<common::Cle*, common::Valeur*>($1, $3);
	}
    
cle:
	texte {
		$$ = new common::Cle($1);
	}
	
value:
	texte {
		$$ = new common::Valeur($1);
	}
	| nombre {
		$$ = new common::Valeur($1);
	}
	| array {
		$$ = new common::Valeur($1);
	}
	| booleen {
		$$ = new common::Valeur($1);
	}
	| object {
		$$ = new common::Valeur($1);
		
	}
	| NUL {
		$$ = new common::Valeur(new common::Nombre(0, common::NombreType::ERREUR_TYPE));
	}
	
booleen:
	BOOLEAN {
		$$ = new common::Booleen($1);
	}
	
nombre:
	FLOAT {
		$$ = new common::Nombre($1);
	}
	| ENTIER {
		$$ = new common::Nombre($1, common::NombreType::ENTIER);
	}

texte:
	TEXTE {
		$$ = new common::Texte($1);
	}
	
array:
	'[' avalue ']' {
		$$ = new common::Tableau();
		for (unsigned int i = $2.size(); i > 0; i--) {
			$$->addValue($2.at(i-1));
		}
		
	}
	| '[' ']' {
		$$ = new common::Tableau();
	}
	
avalue:
	value {
		$$.push_back($1);
	}
	| value ',' avalue {
		$$ = $3;
		$$.push_back($1);
	}

%%

void json::parser::error( const location_type &l, const std::string & err_msg) {
    std::cerr << "Erreur : " << l << ", " << err_msg << std::endl;
}
