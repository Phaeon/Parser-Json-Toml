#include <iostream>
#include <fstream>

#include "json/jsonParser.hh"
#include "toml/tomlParser.hh"
#include "common/texte.h"

int main(int argc, const char* argv[]) {
	
	if (argc != 3) {
		std::cerr << "Mauvais usage de la commande." << std::endl;
		std::cout << "\tUsage: ./comparator <TOMLFile> <JSONFile>" << std::endl;
		return EXIT_FAILURE;
	}

	std::ofstream jsonFile("json.txt"), tomlFile("toml.txt");
	// Code erreur : Surtout pour le cas où il s'agit d'une erreur de parsing de JSON ET TOML (3)
	int errorCode(0);
    
    	std::cout << "******** Json *******" << std::endl;
    	auto json = parseJSON(argv[2]);
    	// Si le parser ne fonctionne pas, parseJSON renvoit nullptr.
    	if (json == nullptr) errorCode = errorCode + 2;
		else {
			std::cout << "Fichier JSON parsé avec succès." << std::endl;
			std::cout << std::endl;
			
				std::cout << "Fichier json.txt généré avec la conversion textuelle." << std::endl;
				std::string texteJSON = json->toTXT();
				jsonFile << texteJSON;
				jsonFile.close();
				std::cout << std::endl;
			 
		}
		
    	std::cout << "******** Toml *******" << std::endl;
    	auto toml = parseTOML(argv[1]);
    	// Si le parser ne fonctionne pas, parseTOML renvoit nullptr.
    	if (toml == nullptr) errorCode++;
		else{
			std::cout << "Fichier TOML parsé avec succès." << std::endl;
		
				std::cout << std::endl;
				std::cout << "Fichier toml.txt généré avec la conversion textuelle." << std::endl;
				std::string texteTOML = toml->toTXT();
				tomlFile << texteTOML;
				tomlFile.close(); 
			
		}
		
    
    std::cout << std::endl;
    
    std::cout << "******** ANALYSE DES FICHIERS *******" << std::endl;
    if (errorCode == 0) {
    	if (*json == *toml) {
    		std::cout << "Les fichiers sont identiques." << std::endl;
    	}
    	else {
    		std::cerr << "Les fichiers ne sont pas identiques." << std::endl;
    		return 255;
    	}
    }else{
    	std::cerr << "Aucune analyse possible" << std::endl;	
    }
	
	std::cout << "Code erreur : " << errorCode << std::endl;
    return errorCode;
}