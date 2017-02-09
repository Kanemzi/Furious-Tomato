
/* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
 *   Furious Tomato - Par Benjamin Strabach, Valentin Galerne et Simon Rozec   *
 *                                                                             *
 *                    ~ Gestion de l'écran de fin de partie ~                  *
 * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * */

boolean fin_init = false;

final float degrade_speed_ecran_mort = 255 / (IMAGES_PAR_SECONDE * 1);

float texte_degrade_speed = 2;

float opacite_ecran_mort;
float opacite_texte;

float x_mort = 0, y_mort = 0;

Image img_tomate_morte;
Image derniere_image;

void initialiser_fin()
{
    derniere_image = new Image(ecran.get());
    
    opacite_ecran_mort = 0;
    opacite_texte = 0;
    
    img_tomate_morte = new Image(IMAGE_TOMATE_MORT, 12, 0, ANIMATION_TOMATE_MORT, false);
	img_tomate_morte.index_image = 11;
	img_tomate_morte.opacite(100);
}


void mettre_a_jour_fin()
{
    if (opacite_texte >= 255)
    {
        texte_degrade_speed =  - 255 / (IMAGES_PAR_SECONDE * 1);
    }
    
    if (opacite_texte < 0)
    {
        texte_degrade_speed =  255 / (IMAGES_PAR_SECONDE * 1);
    }
    
    opacite_texte += texte_degrade_speed;
    opacite_ecran_mort += degrade_speed_ecran_mort;

	if(touches[ENTER] && opacite_ecran_mort >= 400)
	{
    	demande_menu = true;
    	transition.lancer();
	}

	if(transition.demi_transition_passee() && demande_menu) // si la transition arrive à la moitié et qu'on demande bien un retour au menu
    {
        demande_menu = false;
        terminer_fin(); // on quitte l'écran crédits
    }
}


void dessiner_fin()
{
    derniere_image.afficher(0, 0);
    
    ecran.noStroke();
    ecran.fill(0, opacite_ecran_mort);
    ecran.rect(0, 0, LARGEUR_ECRAN, HAUTEUR_ECRAN);
    
    img_tomate_morte.afficher(x_mort, y_mort);
    
    if ( opacite_ecran_mort >= 400)
    {
        ecran.textSize(24);
        ecran.fill(255, 255, 255);
        ecran.textAlign(CENTER);
        ecran.text("Vous avez perdu", LARGEUR_ECRAN / 2, HAUTEUR_ECRAN / 2);

        ecran.textSize(TAILLE_POLICE-1);
        ecran.fill(120, 120, 120, opacite_texte);
        ecran.text("Presser [Entrer] pour retourner au menu", LARGEUR_ECRAN/2, HAUTEUR_ECRAN/2 + 20);
    }
}


void terminer_fin()
{
    scene = SCENES[MENU];
    fin_init = false;
}