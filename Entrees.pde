/* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
 *   Furious Tomato - Par Benjamin Strabach, Valentin Galerne et Simon Rozec   *
 *                                                                             *
 *                   ~ Fichier de gestion des entrées clavier ~                *
 * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * */
 
boolean[] touches = new boolean[256];

boolean touche_pressee = false;
boolean touche_relachee = false;

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