/* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
 *   Furious Tomato - Par Benjamin Strabach, Valentin Galerne et Simon Rozec   *
 *                                                                             *
 *                    ~ Fichier de gestion de la sauvegarde ~                  *
 * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * */

String meilleur_score;
String[] data;
boolean score_battu = false;

//---------------------------------------------------------------------------------------------------------------------
void test_meilleur_score() {
    if(temps_partie <= Integer.parseInt(meilleur_score)) 
            return;
    sauver_score();
    score_battu = true;
}
//---------------------------------------------------------------------------------------------------------------------
void charger_score() {
  data = loadStrings("score.sav");    
  if (data == null || data.length <= 0) {
    meilleur_score = "0";
  } else {
      if (data[0] == "") {
          meilleur_score = "0";
      } else {
         dechiffrer_score();
         meilleur_score = data[0]; 
      }
  }
}
//---------------------------------------------------------------------------------------------------------------------
void sauver_score() {
     meilleur_score = str(temps_partie);
    data = new String[1];
    data[0] = meilleur_score;
    chiffrer_score();
    saveStrings("score.sav", data);
}
//---------------------------------------------------------------------------------------------------------------------
void chiffrer_score() {
  	int longdata = data[0].length();
	int cle = int(random(16));

	String chiffrage = str(char(cle + 64));
	for(int i = 0; i < longdata; i++) {
	chiffrage += str(char(data[0].charAt(i) + 16 + cle));
	}
	data[0] = chiffrage;
	//println(data[0]);
}

void dechiffrer_score() {
  	int longdata = data[0].length() - 1;
	int cle = data[0].charAt(0) - 64;

	String dechiffrage = "";
	for (int i = 1;  i < longdata + 1; i++) {
    dechiffrage += str(char(data[0].charAt(i) - 16 - cle));
	}
	data[0] = dechiffrage;
	//println(data[0]);
}




/* --> Fin de partie
Si le score actuel > le meilleur score
    Le meilleur score prend la valeur du score actuel
    On chiffre le meilleur score et on le stocke dans une variable
    On sauvegarde le meilleur score chiffré dans un fichier