/* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
 *   Furious Tomato - Par Benjamin Strabach, Valentin Galerne et Simon Rozec   *
 *                                                                             *
 *                       ~ Gestion de l'écran des crédits ~                    *
 * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * */

boolean credits_init = false;
boolean retour_active;

boolean entrer_presse;

Image fond_credits;
Image bouton_entrer;


void initialiser_credits()
{
    fond_credits = new Image(IMAGE_FOND_CREDITS);
    bouton_entrer = new Image(IMAGE_BOUTON_ENTRER);
    retour_active = false;
    entrer_presse = false;
}


void mettre_a_jour_credits()
{
    if(!touches[ENTER])
    {
    	retour_active = true;   
    	
    	if(entrer_presse)
    	{
        	terminer_credits();
    	}
	}
    
    if(touches[ENTER] && retour_active)
    {
        entrer_presse = true;
    }
}


void dessiner_credits()
{
    fond_credits.afficher(0, 0);
    ecran.fill(#f0f0f0);
    ecran.textAlign(CENTER);
    ecran.text("Par \nBenjamin STRABACH \n Simon ROZEC \n Valentin GALERNE", LARGEUR_ECRAN / 2, 64);
    
    if(entrer_presse)
    {
    	bouton_entrer.afficher(10, 143);   
    }
}


void terminer_credits()
{
    scene = SCENES[MENU];
    credits_init = false;
}