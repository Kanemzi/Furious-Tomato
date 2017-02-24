/* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
 *   Furious Tomato - Par Benjamin Strabach, Valentin Galerne et Simon Rozec   *
 *                                                                             *
 *                       ~ Gestion de l'écran des crédits ~                    *
 * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * */

boolean credits_init = false;

boolean retour_active;
boolean credits_entrer_presse;

Image fond_credits;
Image bouton_entrer;


void initialiser_credits()
{
    fond_credits = new Image(IMAGE_FOND_CREDITS);
    bouton_entrer = new Image(IMAGE_BOUTON_ENTRER);
    retour_active = false;
    credits_entrer_presse = false;

    demande_menu = false;
}


void mettre_a_jour_credits()
{
    if (!touches[ENTER])
    {
        retour_active = true; // permet le retour au menu si "entrer" a été relâché depuis l'entrée dans cet écran

        if (credits_entrer_presse && !demande_menu) // si on relâche après avoir sélectionné le bouton de retour
        {
            demande_menu = true; // on lance la transition pour retourner au menu
            transition.lancer();
        }
    }

    if (touches[ENTER] && retour_active) // on enclenche le retour au menu
    {
        credits_entrer_presse = true;
    }

    if (transition.demi_transition_passee() && demande_menu) // si la transition arrive à la moitié et qu'on demande bien un retour au menu
    {
        demande_menu = false;
        terminer_credits(); // on quitte l'écran crédits
    }
}


void dessiner_credits()
{
    fond_credits.afficher(0, 0);

    ecran.fill(#f0f0f0);
    ecran.textAlign(CENTER);
    ecran.text("Par \nBenjamin STRABACH \n Simon ROZEC \n Valentin GALERNE", LARGEUR_ECRAN / 2, 64);

    if (credits_entrer_presse)
    {
        bouton_entrer.afficher(10, 143);
    }
}


void terminer_credits()
{
    scene = SCENES[MENU];
    credits_init = false;
}