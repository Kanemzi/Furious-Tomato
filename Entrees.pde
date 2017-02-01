/* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
 *   Furious Tomato - Par Benjamin Strabach, Valentin Galerne et Simon Rozec   *
 *                                                                             *
 *                   ~ Fichier de gestion des entrées clavier ~                *
 * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * */
 
boolean[] touches = new boolean[256];

void keyPressed()
{
	touches[keyCode] = true;   
}

void keyReleased()
{
	touches[keyCode] = false;
	menu.k = false;
}