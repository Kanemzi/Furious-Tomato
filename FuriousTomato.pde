/* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
 *   Furious Tomato - Par Benjamin Strabach, Valentin Galerne et Simon Rozec   *
 *                                                                             *
 *                             ~ Fichier principal ~                           *
 * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * */

String scene;
int temps_global;

Transition transition;
Tremblement tremblement;

void settings()
{
    switch(ECHELLE)
    {
    case 1:
        size(320, 180);
        break;

    case 2:
        size(640, 360);
        break;

    case 3:
        size(960, 540);
        break;

    case 4:
        size(1280, 720);
        break;
    }

    noSmooth();
}


void setup()
{
    frameRate(IMAGES_PAR_SECONDE);

    temps_global = 0;
    scene = SCENES[INTRO];

    initialiser_ecran();
    initialiser_police();

    transition = new Transition();
    tremblement = initialiser_tremblement();
}


void draw()
{
    //surface.setLocation((int)(64 + sin((float)temps_global /( (float)IMAGES_PAR_SECONDE / 5))* 64) , (int) (64 + cos((float)temps_global / ((float)IMAGES_PAR_SECONDE / 5))* 64) ); // faire bouger l'écran lel !!! x) x) xD ptdr

    temps_global ++;

    surface.setTitle("Furious Tomato    (fps: "+(int) frameRate + ")");

    ecran.beginDraw();
    
    masque_couteaux.beginDraw();
    masque_couteaux.clear();

	tremblement.mettre_a_jour();

    if (scene == SCENES[INTRO])
    {
        if (!intro_init)
        {
            intro_init = true;
            initialiser_intro();
        }

        mettre_a_jour_intro();
        dessiner_intro();
    } 
    else if (scene == SCENES[MENU])
    {
        if (!menu_init)
        {
            menu_init = true;
            initialiser_menu();
        }

        mettre_a_jour_menu();
        dessiner_menu();
    }
    else if (scene == SCENES[CREDITS])
    {
        if (!credits_init)
        {
            credits_init = true;
            initialiser_credits();
        }

        mettre_a_jour_credits();
        dessiner_credits();
    }
    else if (scene == SCENES[JEU])
    {
        if (!jeu_init)
        {
            jeu_init = true;
            initialiser_jeu();
        }

        mettre_a_jour_jeu();
        dessiner_jeu();
    }
    else if (scene == SCENES[FIN])
    {
        if (!fin_init)
        {
            fin_init = true;
            initialiser_fin();
        }

        mettre_a_jour_fin();
        dessiner_fin();
    }

    transition.mettre_a_jour();
    transition.afficher();
	
	//couper_masque_couteaux();
	masque_couteaux.endDraw();
	
	ecran.image(masque_couteaux, 0, HAUTEUR_ECRAN - HAUTEUR_PLANCHE);

    ecran.endDraw();

    pushMatrix();
    scale(ECHELLE, ECHELLE);
    image(ecran, 0, 0);
    popMatrix();

    mettre_a_jour_entrees();
}