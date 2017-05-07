/* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
 *   Furious Tomato - Par Benjamin Strabach, Valentin Galerne et Simon Rozec   *
 *                                                                             *
 *                     ~ Gestion de l'écran d'introduction ~                   *
 * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * */

boolean intro_init = false;

float opacite_intro = -100;
float degrade_speed_intro = 255 / (IMAGES_PAR_SECONDE);

boolean son_joue = false; // le son de l'intro a été joué

Image logo;


void initialiser_intro()
{
    logo = new Image(IMAGE_LOGO_INTRO);
}


void mettre_a_jour_intro()
{
    if (opacite_intro > 400)
    {
        degrade_speed_intro = - 255 / (IMAGES_PAR_SECONDE * 1.5);
        
        if(!son_joue)
        {
            son_intro.trigger();
        	son_joue = true;	   
        }
    }

    if (opacite_intro < -100 || touches[TOUCHE_VALIDER] || touches[TOUCHE_IMPULSION])
    {
        terminer_intro();
    }

    opacite_intro += degrade_speed_intro;
}


void dessiner_intro()
{
    ecran.fill(0);
    ecran.rect(0, 0, LARGEUR_ECRAN, HAUTEUR_ECRAN);

    logo.opacite = opacite_intro;
    logo.afficher(LARGEUR_ECRAN  / 2 - logo.largeur / 2, HAUTEUR_ECRAN / 2 - logo.hauteur / 2);
}


void terminer_intro()
{
    scene = SCENES[MENU];
    intro_init = false;
}