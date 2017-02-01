/* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
 *   Furious Tomato - Par Benjamin Strabach, Valentin Galerne et Simon Rozec   *
 *                                                                             *
 *                       ~ Gestion de l'écran des crédits ~                    *
 * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * */

boolean credits_init = false;
boolean retour_active;

Image img;

void initialiser_credits()
{
    retour_active = false;
}


void mettre_a_jour_credits()
{
    if(!touches[ENTER])
    {
    	retour_active = true;   
    }
    
    if(touches[ENTER] && retour_active)
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
    credits_init = false;
}