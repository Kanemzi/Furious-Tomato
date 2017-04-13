/* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
 *   Furious Tomato - Par Benjamin Strabach, Valentin Galerne et Simon Rozec   *
 *                                                                             *
 *                    ~ Gestion de l'écran de fin de partie ~                  *
 * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * */

boolean fin_init = false;

final float degrade_speed_ecran_mort = 255 / (IMAGES_PAR_SECONDE * 1.5);

float texte_degrade_speed = 2;

float opacite_ecran_mort;
float opacite_texte;

float x_mort = 0, y_mort = 0;

Image img_tomate_morte;
Image derniere_image;


String ms = "MEILLEUR SCORE !";
int curseur_hola_ms;


// feu d'artifices meilleur score :
int nb_feu_restant;
int delais_prochain_feu;
ArrayList<FeuArtifice> arts = new ArrayList<FeuArtifice>();

void initialiser_fin()
{
    derniere_image = new Image(ecran.get());

    opacite_ecran_mort = 0;
    opacite_texte = 0;

    img_tomate_morte = new Image(IMAGE_TOMATE_MORT, 12, 0, ANIMATION_TOMATE_MORT, false);
    img_tomate_morte.index_image = 11;
    img_tomate_morte.opacite(100);

    curseur_hola_ms = 0;
    nb_feu_restant = (int) random(3, 200);
    delais_prochain_feu = 0;

    test_meilleur_score();
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

    if (touches[ENTER] && touche_pressee && opacite_ecran_mort >= 400)
    {
        demande_menu = true;
        son_bouton_retour.trigger();

        transition.lancer();
    }

    if (transition.demi_transition_passee() && demande_menu) // si la transition arrive à la moitié et qu'on demande bien un retour au menu
    {
        demande_menu = false;
        terminer_fin(); // on quitte l'écran crédits
    }
}


void dessiner_fin()
{
    derniere_image.afficher(0, 0);

    ecran.fill(0, opacite_ecran_mort);
    ecran.rect(0, 0, LARGEUR_ECRAN, HAUTEUR_ECRAN);

    img_tomate_morte.afficher(x_mort, y_mort);

    if ( opacite_ecran_mort >= 400)
    {
        ecran.textSize(24);
        ecran.fill(255, 255, 255);
        ecran.textAlign(CENTER);
        ecran.text("Vous avez perdu", LARGEUR_ECRAN/2, HAUTEUR_ECRAN/2 - 10);
        ecran.textSize(TAILLE_POLICE-1);
        ecran.text("Temps survécu : " + temps_partie + " secondes", LARGEUR_ECRAN/2, HAUTEUR_ECRAN/2 + 10);

        ecran.textSize(TAILLE_POLICE-1);
        ecran.fill(120, 120, 120, opacite_texte);
        ecran.text("Presser [Entrer] pour retourner au menu", LARGEUR_ECRAN/2, HAUTEUR_ECRAN/2 + 80);

        if (score_battu == true && opacite_ecran_mort >= 500) // affichage du meilleur score
        {
            ecran.textSize(18);
            ecran.fill(255, 255, 255);

            if (temps_global % 3 == 0) curseur_hola_ms ++;
            if (curseur_hola_ms >= ms.length() + 10) curseur_hola_ms = -2;

            float char_larg = textWidth(ms) / ms.length() + 2.5;
            for (int i = 0; i < ms.length(); i++)
            {
                int decalage = 0;
                if (i - curseur_hola_ms == 0) decalage = 8;
                else decalage = 6 / abs(i - curseur_hola_ms);

                ecran.text(ms.charAt(i), LARGEUR_ECRAN/2 - textWidth(ms) / 2 + i*char_larg - 14, HAUTEUR_ECRAN/2 + 40 - decalage);
            }
            
            
            for(FeuArtifice fa : arts)
            {
            	fa.afficher();
            }
            
            if(delais_prochain_feu <= 0 && nb_feu_restant > 0)
            {
                delais_prochain_feu = (int) (random(0.2, 2) * IMAGES_PAR_SECONDE);
                arts.add(new FeuArtifice(new Vecteur(random(LARGEUR_ECRAN), random(HAUTEUR_ECRAN)), 0.2, (int) random(20, 70)));
            	
            	nb_feu_restant--;
            	println("creation feu");
        	}
            else
            {
            	delais_prochain_feu --;   
            }
        }
    }
}


void terminer_fin()
{
    scene = SCENES[MENU];
    fin_init = false;
    score_battu = false;
    arts.clear();
}