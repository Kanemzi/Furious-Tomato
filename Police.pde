/* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
 *   Furious Tomato - Par Benjamin Strabach, Valentin Galerne et Simon Rozec   *
 *                                                                             *
 *                    ~ Chargement de la police d'écriture ~                   *
 * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * */

PFont police;


void initialiser_police()
{
  police = createFont(POLICE, TAILLE_POLICE);

  ecran.beginDraw();
  ecran.textFont(police, TAILLE_POLICE);
  ecran.endDraw();
}