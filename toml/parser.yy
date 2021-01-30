%skeleton "lalr1.cc"
%require "3.2"

%defines
%define api.namespace { toml }
%define api.parser.class { parser }
%define api.value.type variant
%define parse.assert
%define parse.trace

%locations

%code requires{


    namespace toml {
        class scanner;
    }

    #include "common.hh"
}

%parse-param { toml::scanner &scanner }
%parse-param { common::driver &driver }

%code{
    #include <iostream>
    #include <string>
    #include <list>
    #include <map>
    
    #include "scanner.hh"

    #undef  yylex
    #define yylex scanner.yylex
}

%token                  END NUL INF NAN SIGNE
%token 					ARRAY_OPEN ARRAY_CLOSE ARRAY_TABLE_OPEN ARRAY_TABLE_CLOSE
%token <float>    		NUMBER FLOAT HEXA
%token <std::string>	POINT TEXTE UNESCAPED UNQUOTED_KEY ESCAPE ESCAPE_CHAR BIN OCTA
%token <int>			ENTIER
%token <bool>			BOOLEAN

%type <std::vector<common::Cle*> >    	dotted_key
%type <common::Cle*>					cle
%type <common::Nombre*>					integer float
%type <common::Valeur*> 				value
%type <std::vector<common::Valeur*> > 	avalues
%type <common::Tableau*> 				array
%type <common::Texte*>					simple_key quoted_key

%%

document:
    toml {
    	YYACCEPT;
    }
    | END {
    	YYACCEPT;
    }
    | error document {yyerrok;}
    
toml:
	expression
	| expression toml
	
expression:
	cle '=' value {
		driver.getObjetCourant()->ajoutElement($1, $3);
	}
	| dotted_key '=' value {
	
		/*
		* Dotted Keys:
		* 	Je construis une paire dotted_key/Valeur de manière ascendante, donc
		*	travailler sur la clé de la droite vers la gauche.
		*/
		
		common::Valeur* valeurCourante = $3;
		common::Objet* objC = driver.getObjetCourant();
		common::Objet* o;
		unsigned int compteur = 0;
		
		// On travaille ici sur toutes les clés sauf la dernière
		for (unsigned int i(0); i < $1.size() - 1; i++) {
			o = new common::Objet();
			if (objC->contains($1.at($1.size() - 1 - i))) {
				if (dynamic_cast<common::Objet*>(objC->getLignes().at(objC->getCle($1.at($1.size() - 1 - i)->getNomCle()))->getElements().front()) == nullptr) {
					std::cout << "[Dotted Key] : Une valeur est déjà associée à une des clés." << std::endl;
					YYABORT;
				}
				compteur++;
				objC = static_cast<common::Objet*>(objC->getLignes().at(objC->getCle($1.at($1.size() - 1 - i)->getNomCle()))->getElements().front());
			}else{
				o->ajoutElement($1.at(i - compteur), valeurCourante);
				valeurCourante = new common::Valeur(o);
			}
		}
		
		if (objC->contains($1.at($1.size() - 1 - compteur)) && compteur+1 == $1.size()) {
			std::cout << "[Dotted Key] : Un objet est déjà associée à la clé." << std::endl;
			YYABORT;
		}
		objC->ajoutElement($1.at($1.size() - 1 - compteur), valeurCourante);
		
		
		
	}
	| ARRAY_OPEN cle ARRAY_CLOSE {
		
		driver.setObjetCourant(driver.getMainObject());
		
		common::Objet* objC;
		bool existe = false;
		
		for (auto ele : driver.getObjetCourant()->getLignes()) {
			
			// Si la clé de la table existe déjà, il faut vérifier qu'il s'agit bien de la clé d'un objet et non une valeur
			if (ele.first->getNomCle() == $2->getNomCle()){
			
				if (dynamic_cast<common::Objet*>(driver.getObjetCourant()->getLignes().at(ele.first)->getElements().front()) != nullptr) {
					objC = static_cast<common::Objet*>(driver.getObjetCourant()->getLignes().at(ele.first)->getElements().front());
					existe = true;
				}else{
					std::cout << "[Table Standard] La clé de table n'est pas associée à un objet." << std::endl;
					YYABORT;
				}
				break;
				
			}
        }
        
        /* Si la table est rencontée pour la première fois, ou si l'objet principal est vide, 
        	on crée un nouvel objet associé à la clé de la table. */
        if (driver.getMainObject()->getLignes().size() == 0 || !existe) {
			objC = new common::Objet();
			driver.getObjetCourant()->ajoutElement($2, new common::Valeur(objC));
		}
        
		driver.setObjetCourant(objC);
		
	}
	| ARRAY_OPEN dotted_key ARRAY_CLOSE {
	
		// On récupère la table courante si nous y sommes, sinon récupérer l'objet principal
		driver.setObjetCourant((driver.getTableCourant()->getLignes().size() == 0) ? driver.getMainObject() : driver.getTableCourant());
		
		
		common::Valeur* valeurCourante = new common::Valeur(new common::Objet());
		common::Objet* objC = driver.getObjetCourant();
		common::Objet* o;
		unsigned int compteur = 0; // Nombre de clés du dotted_key déjà présentes.
		
		// N'est pas null si nous sommes dans un array of tables
		if (driver.getCleTable() != nullptr) {
			if (driver.getCleTable()->getNomCle() != $2.at($2.size() - 1)->getNomCle()) {
				std::cout << "[Table Standard] : Impossible d'associer une table à l'array " << driver.getCleTable()->getNomCle() << "." << std::endl;
				YYABORT;
			}
			
			// Ne pas traiter la clé de la table, étant donné que nous y sommes déjà
			$2.pop_back();
		}
		
		/*
		* Les clés sont stockés de la droite vers la gauche.
		* Comme les paires dotted_keys/Valeur, on construit l'objet de manière ascendante.
		* On se réserve la dernière valeur du vector comme la clé qui associe l'objet créé (Donc i allant de 0 à size - 2)
		*/
		for (unsigned int i(0); i < $2.size() - 1; i++) {
			o = new common::Objet();
			
			// Si l'objet courant contient déjà la clé, alors on souhaite retrouver l'objet associé à cette clé.
			// Sinon associer la nouvelle clé avec la valeure courante.
			if (objC->contains($2.at($2.size() - 1 - i))) {
				
				if (dynamic_cast<common::Objet*>(objC->getLignes().at(objC->getCle($2.at($2.size() - 1 - i)->getNomCle()))->getElements().front()) == nullptr) {
					std::cout << "[Table Standard] : Une valeur est déjà associée à une des clés." << std::endl;
					YYABORT;
				}
				
				// Récupérer l'objet associé à la clé déjà existante.
				objC = static_cast<common::Objet*>(objC->getLignes().at(objC->getCle($2.at($2.size() - 1 - i)->getNomCle()))->getElements().front());
				compteur++;
				
			}else{
				o->ajoutElement($2.at(i - compteur), valeurCourante);
				valeurCourante = new common::Valeur(o);
			}
		}
		
		if (objC->contains($2.at($2.size() - 1 - compteur)) && compteur+1 == $2.size()) {
			std::cout << "[Table Standard] : Un objet est déjà associée à la clé." << std::endl;			
			YYABORT;
		}
		objC->ajoutElement($2.at($2.size() - 1 - compteur), valeurCourante);
		
		// On souhaite pointer vers l'objet le plus profond parmis ceux qu'on a crée.
		for (unsigned int i = compteur; i < $2.size(); i++) {
			objC = static_cast<common::Objet*>(objC->getLignes().at(objC->getCle($2.at($2.size() - 1 - i)->getNomCle()))->getElements().front());
		}
		
		driver.setObjetCourant(objC);
		
		
		
	}
	| ARRAY_TABLE_OPEN cle ARRAY_TABLE_CLOSE {
		
		driver.setObjetCourant(new common::Objet());
		
		bool existe = false;
		// On vérifie d'abord si la table n'existe pas déjà.
		for (auto ele : driver.getMainObject()->getLignes()) {
			
			if (ele.first->getNomCle() == $2->getNomCle()){
				// 
				if (driver.getMainObject()->contains(ele.first) && dynamic_cast<common::Tableau*>(driver.getMainObject()->getLignes().at(ele.first)) != nullptr) {
					std::cout << "[Array of tables] : Une table standard existe déjà avec cette clé" << std::endl;
					YYABORT;
				}
				
				if (dynamic_cast<common::Objet*>(driver.getMainObject()->getLignes().at(ele.first)) != nullptr) {
					std::cout << "[Array of tables] : Un objet existe déjà avec cette clé." << std::endl;
					YYABORT;
				}
				existe = true;
				break;
			}
        }
        
        common::Objet* objC = new common::Objet();
        
        // Si la table existe déjà, on récupère le tableau qui lui est associé et en ajoutant un nouvel objet
        if (existe) {
        	common::Tableau* tab = static_cast<common::Tableau*>(driver.getMainObject()->getLignes().at(driver.getMainObject()->getCle($2->getNomCle()))->getElements().front());
        	tab->addValue(new common::Valeur(objC));
        } else {
        	common::Tableau* tab = new common::Tableau();
        	tab->addValue(new common::Valeur(objC));
        	driver.getMainObject()->ajoutElement($2, new common::Valeur(tab));
        }
        
        driver.setObjetCourant(objC); 
        driver.setTableCourant(objC); // Cette table devient donc la tablue courante
        driver.setCleTable($2);
		
	}
	| ARRAY_TABLE_OPEN dotted_key ARRAY_TABLE_CLOSE {
	
		// Dans le cas où le array of tables initial n'a été initialisé précédemment
		if (driver.getCleTable() == nullptr || driver.getCleTable()->getNomCle() != $2.at($2.size() - 1)->getNomCle()) {
			std::cout << "[Array of tables] Une table " << $2.at($2.size() - 1)->getNomCle() << " n'a été créé précédemment." << std::endl;
			YYABORT;
		}
        
        for (auto ele : driver.getTableCourant()->getLignes()) {
			if (ele.first->getNomCle() == $2.at(0)->getNomCle() && dynamic_cast<common::Tableau*>(driver.getTableCourant()->getLignes().at(ele.first)->getElements().front()) == nullptr){
				std::cout << "[Array of tables] La clé existante la plus profonde correspond déjà à une clé d'objet et non de tableau." << std::endl;
				YYABORT;
			}
        }
        
        // Récupérer la table courante et enlever la clé de la table du vecteur
		common::Objet* objC = driver.getTableCourant();
		$2.pop_back();
		
		common::Objet* o;
		unsigned int compteur = 0; // Nombre de clés déjà existants
		
		for (unsigned int i(0); i < $2.size() - 1; i++) {
			
			o = new common::Objet();
			// Si la clé existe déjà, on pointe alors vers l'objet associé à cette clé.
			if (objC->contains($2.at($2.size() - 1 - i))) {
				objC = static_cast<common::Objet*>(objC->getLignes().at(objC->getCle($2.at($2.size() - 1 - i)->getNomCle())));
				compteur++;
			}else{
				objC->ajoutElement($2.at($2.size() - 1 - i - compteur), o);
				objC = o;
			}
			
		}
		
		// Vérifier si la dernière clé existe déjà, si c'est le cas, on récupère le tableau associé et on créé un nouvel objet.
		if (objC->contains($2.at(0))) {
			
			common::Tableau* tab = static_cast<common::Tableau*>(objC->getLignes().at(objC->getCle($2.at(0)->getNomCle()))->getElements().front());
			common::Objet* temp = new common::Objet();
			
			tab->addValue(new common::Valeur(temp));
			objC = temp;
			
		} else {
		
			common::Tableau* tab = new common::Tableau();
			common::Objet* temp = new common::Objet();
			tab->addValue(new common::Valeur(temp));
			objC->ajoutElement($2.at(0), new common::Valeur(tab));
			objC = temp;
			
		}
		
		driver.setObjetCourant(objC);
		
	}
	
	
cle:
	simple_key {
		for (auto ele : driver.getObjetCourant()->getLignes()) {
        	if (ele.first->getNomCle() == $1->getValue()) {
        		std::cout << "La clé " << $1->getValue() << " existe déjà." << std::endl;
        		YYABORT;
        	}
        }
		
		$$ = new common::Cle($1);
	}

simple_key:
	quoted_key {
		$$ = $1;
	}
	| UNQUOTED_KEY {
		$$ = new common::Texte('"' + $1 + '"');
	}
	| ENTIER {
		$$ = new common::Texte('"' + std::to_string($1) + '"');
	}
	| FLOAT {
		$$ = new common::Texte('"' + std::to_string($1) + '"');
	}
	
quoted_key:
	TEXTE {
		$$ = new common::Texte($1);
	}
	
dotted_key:
	simple_key POINT simple_key {
		$$ = std::vector<common::Cle*>();
		
        $$.push_back(new common::Cle($3));
        $$.push_back(new common::Cle($1));
	}
	| simple_key POINT dotted_key {
		$$ = $3;
        $$.push_back(new common::Cle($1));
	}
	
value:
	TEXTE {
		$$ = new common::Valeur(new common::Texte($1));
	}
	| BOOLEAN {
		$$ = new common::Valeur(new common::Booleen($1));
	}
	| array {
		$$ = new common::Valeur($1);
	}
	| float {
		$$ = new common::Valeur($1);
	}
	| integer {
		$$ = new common::Valeur($1);
	}
	
integer:
	ENTIER {
		$$ = new common::Nombre($1, common::NombreType::ENTIER);
	}
	| HEXA {
		$$ = new common::Nombre($1, common::NombreType::HEXA);
	}
	| OCTA {
		$$ = new common::Nombre(std::atof($1.substr(2).c_str()), common::NombreType::OCTAL);
	}
	| BIN {
		$$ = new common::Nombre(std::atof($1.substr(2).c_str()), common::NombreType::BINAIRE);
	}
	
float:
	FLOAT {
		$$ = new common::Nombre($1, common::NombreType::DECIMAL);
	}
	| INF {
		$$ = new common::Nombre(0, common::NombreType::ERREUR_TYPE);
	}
	| NAN {
		$$ = new common::Nombre(0, common::NombreType::ERREUR_TYPE);
	}
	
array:
	ARRAY_OPEN avalues ARRAY_CLOSE  {
		$$ = new common::Tableau();
		for (unsigned int i = $2.size(); i > 0; i--) {
			$$->addValue($2.at(i-1));
		}
		
	}
	| ARRAY_OPEN ARRAY_CLOSE {
		$$ = new common::Tableau();
	}
	
avalues:
	value ',' avalues {
		$$ = $3;
		$$.push_back($1);
	}
	| value ',' {
		$$.push_back($1);
	}
	| value {
		$$.push_back($1);
	} 

	

%%

void toml::parser::error( const location_type &l, const std::string & err_msg) {
    std::cerr << "Erreur : " << l << ", " << err_msg << std::endl;
}
