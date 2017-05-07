/* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
 *   Furious Tomato - Par Benjamin Strabach, Valentin Galerne et Simon Rozec   *
 *                                                                             *
 *                   ~ Fichier de gestion des entrées clavier ~                *
 * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *  */

boolean[] touches = new boolean[600]; // tableau contenant les états des touches

boolean touche_pressee = false; // = true si une touche est pressée pendant la frame
boolean touche_relachee = false; // = true si une touche est relâchée pendant la frame


void keyPressed()
{
  touches[keyCode] = true;
  touche_pressee = true;
}


void keyReleased()
{
  touches[keyCode] = false;
  touche_relachee = true;
}


void mettre_a_jour_entrees()
{
  touche_pressee = false;
  touche_relachee = false;
} 