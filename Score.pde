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
  //dechiffrer_score();
  if (data == null || data.length <= 0) {
    meilleur_score = "0";
  } else {
      if (data[0] == "") {
          meilleur_score = "0";
      } else {
         meilleur_score = data[0]; 
      }
  }
}
//---------------------------------------------------------------------------------------------------------------------
void sauver_score() {
     meilleur_score = str(temps_partie);
    data = new String[1];
    data[0] = meilleur_score;
    //chiffrer_score();
    saveStrings("score.sav", data);
}
//---------------------------------------------------------------------------------------------------------------------
void chiffrer_score() {
  // -> On chiffre la variable "data".
}
//---------------------------------------------------------------------------------------------------------------------
void dechiffrer_score() {
  // -> On déchiffre la variable "data".
}




/* --> Fin de partie
Si le score actuel > le meilleur score
    Le meilleur score prend la valeur du score actuel
    On chiffre le meilleur score et on le stocke dans une variable
    On sauvegarde le meilleur score chiffré dans un fichier