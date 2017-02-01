boolean intro_init = false;

float opacite_intro = -100;
float degrade_speed_intro = 255 / (IMAGES_PAR_SECONDE);

Image logo;


void initialiser_intro()
{
	logo = new Image(IMAGE_LOGO_INTRO, 1, 0, ANIMATION_NON);
}


void mettre_a_jour_intro()
{
    if(opacite_intro > 400)
    {
        degrade_speed_intro = - 255 / (IMAGES_PAR_SECONDE * 1.5);
    }
    
    if(opacite_intro < -200)
    {
        terminer_intro();
	}
    
	opacite_intro += degrade_speed_intro;
}


void dessiner_intro()
{
    fill(0);
    rect(0, 0, LARGEUR_ECRAN, HAUTEUR_ECRAN);
    
    logo.opacite = opacite_intro;
    logo.afficher(LARGEUR_ECRAN  / 2 - logo.largeur / 2, HAUTEUR_ECRAN / 2 - logo.hauteur / 2); 
}


void terminer_intro()
{
	ecran = ECRANS[MENU];
}