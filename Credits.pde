/* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
 *   Furious Tomato - Par Benjamin Strabach, Valentin Galerne et Simon Rozec   *
 *                                                                             *
 *                       ~ Gestion de l'écran des crédits ~                    *
 * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * */

boolean credits_init = false;

Image img;

void initialiser_credits()
{
}


void mettre_a_jour_credits()
{
    if(touches[ENTER])
    { 
    	terminer_credits();
	}
}


void dessiner_credits()
{
    ecran.background(#222222);
    ecran.fill(#ffffff);
    ecran.text("Benjamin SBRATCH", 64, 64);
}


void terminer_credits()
{
    scene = SCENES[MENU];
}