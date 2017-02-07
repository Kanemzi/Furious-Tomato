
/* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
 *   Furious Tomato - Par Benjamin Strabach, Valentin Galerne et Simon Rozec   *
 *                                                                             *
 *                    ~ Gestion de l'écran de fin de partie ~                  *
 * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * */
/*
boolean fin_init = false;

final float degrade_speed_ecran_mort = 255 / (IMAGES_PAR_SECONDE * 4);
final float texte_degrade_speed = 2;

float opacite_ecran_mort;
float opacite_texte;

float x_mort, y_mort;

Image img_tomate_morte;

void initialiser_fin()
{	
    opacite_ecran_mort = 0;
    opacite_texte = 0;
    
    img_tomate_morte = new Image(IMAGE_TOMATE_MORT, 12, 0, ANIMATION_TOMATE_MORT, false);
	img_tomate_morte.index_image = 11;
}


void mettre_a_jour_fin()
{
	opacite_ecran_mort += degrade_speed_ecran_mort;

	if(touches[ENTER]) terminer_fin();
}


void dessiner_fin()
{
    ecran.fill(0, opacite_ecran_mort);
    ecran.rect(0, 0, LARGEUR_ECRAN, HAUTEUR_ECRAN);
    
    img_tomate_morte.afficher(x_mort, y_mort);
}


void terminer_fin()
{
    scene = SCENES[MENU];
    fin_init = false;
}
*/