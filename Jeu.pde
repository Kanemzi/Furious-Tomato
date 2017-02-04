/* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
 *   Furious Tomato - Par Benjamin Strabach, Valentin Galerne et Simon Rozec   *
 *                                                                             *
 *                    ~ Gestion de l'écran en cours de partie ~                *
 * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * */

boolean jeu_init = false;
int temps_partie;

Image gui;
Image planche;
Image cuisinier;

Joueur j;
AfficheurLCD lcd;

void initialiser_jeu()
{
    retour_active = false;
    temps_partie = 0;
	gui = new Image(IMAGE_INTERFACE);
	planche = new Image(IMAGE_PLANCHE);
	cuisinier = new Image(IMAGE_CUISINIER, 5, 0.01, ANIMATION_CUISINIER_NORMAL);
	
	j = new Joueur(new Vecteur(64, 64));
	lcd = new AfficheurLCD(new Vecteur(3, 4), 0);
}


void mettre_a_jour_jeu()
{
	if(temps_global % IMAGES_PAR_SECONDE == 0)
	{
    	temps_partie ++;
	}
	
	cuisinier.mettre_a_jour();
	j.mettre_a_jour();
        
}


void dessiner_jeu()
{
    gui.afficher(0, 0);
    planche.afficher(0, 50);
    j.afficher();
    cuisinier.afficher(242, 58);
    
    imge = lcd.generer_image((int )(millis() / 1000));
    ecran.image(imge.actuelle(), 71, 10);
}


void terminer_jeu()
{
    scene = SCENES[MENU];
    jeu_init = false;
}