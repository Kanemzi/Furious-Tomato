/* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
 *   Furious Tomato - Par Benjamin Strabach, Valentin Galerne et Simon Rozec   *
 *                                                                             *
 *                        ~ Fichier de gestion du joueur ~                     *
 * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * */

/*
IDEES : animation quand le joueur est immobile : yeux clignotent / reprend son souffle etc...
 
 */

class Joueur extends Entite
{
    final float VIT_DEP_NORMAL = 2;
    final float VIT_DEP_RALENTI = .8;
    final float VIT_DEP_IMPULSION = 20;

    final int ENDURENCE_MAX = 100;
    final float DUREE_AFFICHAGE_ENDURENCE = 3;

    final float DUREE_IMPULSION = 0.05;


    boolean perdu = false;

    float angle; // direction du joueur	  

    float vit_dep = VIT_DEP_NORMAL; // vitesse de déplacement


    boolean impulsion = false;
    boolean impulsion_disponible = false;
    int temps_debut_impulsion;

    float delais_recuperation;
    float temps_inactif;

    float endurence;
    float endurence_affichee;
    float opacite_endurence;
    int temps_endurence;
    boolean endurence_visible;
    boolean afficher_endurence; // pareil qu'endurence_visible mais en tout ou rien (ignore le fade)
    boolean endurence_regeneration = false;


    boolean immobile = false;
    float moment_arret = 0;

    boolean ralenti = false;
    boolean epuise = false;

    float axeX = 0; // dose de déplacement en X : -1 < x < 1
    float axeY = 0; // dose de déplacement en Y : -1 < y < 1

    final float VITESSE_ANIMATION_COURIR = 0.3;

    Joueur(Vecteur pos)
    {
        super(pos, new Image(IMAGE_TOMATE, 20, 0.4, ANIMATION_TOMATE_PROFIL_FACE, true));
        parametrer_collision(image.largeur / 1.8, new Vecteur(image.largeur / 2, 2 * image.hauteur / 3), AFFICHER_COLLISIONS);
        perdu = false;

        endurence = ENDURENCE_MAX;
        endurence_affichee = endurence;
        opacite_endurence = 2;
        endurence_visible = true;
    }

    void mettre_a_jour()
    {
        super.mettre_a_jour();

        if (!perdu)
        {
            // Gestion des déplacements du joueur
            axeX = 0;
            axeY = 0;

            if (touches[TOUCHE_GAUCHE])  axeX += 1;
            if (touches[TOUCHE_DROITE]) axeX += -1;
            if (touches[TOUCHE_HAUT])    axeY += -1;
            if (touches[TOUCHE_BAS])  axeY += 1;

            if (axeX == 0 && axeY == 0)
            {
                vit_dep = 0;
                if (!immobile)
                {
                    moment_arret = temps_global; 
                    immobile = true;
                }
            } else
            {
                immobile = false;

                if (impulsion)
                {
                    vit_dep = VIT_DEP_IMPULSION;
                } else if (ralenti || epuise)
                {
                    vit_dep = VIT_DEP_RALENTI;
                } else
                {
                    vit_dep = VIT_DEP_NORMAL;
                }

                angle = atan2(axeX, axeY);
            }


            vitesse.modifierAL(angle + PI/2, vit_dep);

            // Collisions avec les bords de la planche
            if (position.x < 0) 
            {
                position.x = 0;
                vitesse.x = 0;
            }

            if (position.x > 218 - image.largeur / 2)
            {
                position.x = 218 - image.largeur / 2;
                vitesse.x = 0;
            }

            if (position.y > HAUTEUR_ECRAN - image.hauteur - 10)
            {
                position.y = HAUTEUR_ECRAN - image.hauteur - 10;
                vitesse.y = 0;
            }

            if (position.y < 37)
            {
                position.y = 37;
                vitesse.y = 0;
            }


            // impulsion
            if (touches[TOUCHE_IMPULSION]) 
            {
                if (impulsion)
                {
                    entites.add(new FantomeJoueur(new Vecteur(position.x + vitesse.x, position.y + vitesse.y), new Image(image.actuelle()), image.miroir_x));

                    if (temps_global - temps_debut_impulsion > DUREE_IMPULSION * IMAGES_PAR_SECONDE)
                    {
                        impulsion = false;
                    }
                } else if (impulsion_disponible && !immobile && !epuise)
                {
                    impulsion = true;
                    impulsion_disponible = false;
                    temps_debut_impulsion = temps_global;
                    endurence -= DIFF_cout_endurence_impulsion;
                    son_impulsion.trigger();
                }
            } else
            {
                impulsion = false;
                impulsion_disponible = true;
            }



            // Gestion de l'animation du joueur

            image.miroir_x = angle > 0 && angle < PI;

            if (angle == 0) // le personnage va vers le bas
            {
                image.changerAnimation(ANIMATION_TOMATE_FACE, VITESSE_ANIMATION_COURIR, false, false, true);
            } else if (angle == -PI/2 || angle == -PI/4 || angle == PI/2 || angle == PI/4)  // le personnage va vers le bas en diagonale
            {
                image.changerAnimation(ANIMATION_TOMATE_PROFIL_FACE, VITESSE_ANIMATION_COURIR, false, false, true);
            } else if (angle == PI)  // le personnage va vers le haut 
            {
                image.changerAnimation(ANIMATION_TOMATE_DOS, VITESSE_ANIMATION_COURIR, false, false, true);
            } else if (angle == -3*PI/4 || angle == 3*PI/4)  // le personnage va vers le haut en diagonale
            {
                image.changerAnimation(ANIMATION_TOMATE_PROFIL_DOS, VITESSE_ANIMATION_COURIR, false, false, true);
            }

            if (vitesse.longueur() == 0)
            {
                image.changerVitesseAnimation(0);
                image.index_image = 0;
            } else 
            {
                image.changerVitesseAnimation(VITESSE_ANIMATION_COURIR);
            }

			// si le joueur est dans le sel
            if (ralenti)
            {
                if (temps_global % 16 == 0) // son des pas du joueur dans le sel
                {
                    son_sel_pas.trigger();   
                }
            }


            if (immobile && (temps_global - moment_arret) > IMAGES_PAR_SECONDE)
            {
                endurence_regeneration = true;
            } else
            {
                endurence_regeneration = false;
            }

            if (endurence_regeneration && temps_global % 2 == 0)
            {
                endurence += 2;
            }


            // gestion de l'épuisement du joueur
            if (endurence <= 0)
            {
                epuise = true;
            }

            if (epuise && endurence >= ENDURENCE_MAX / 2)
            {
                epuise = false;
            }

            if (epuise)
            {
                if (temps_global % (int)(IMAGES_PAR_SECONDE / random(1, 5)) == 0)
                {
                    entites.add(new GoutteEau(new Vecteur(position.x + random(0, image.largeur), position.y + 5)
                        ));
                }
            }


            endurence = max(0, endurence);
            endurence = min(ENDURENCE_MAX, endurence);

            if (endurence_affichee < endurence) endurence_affichee ++;
            if (endurence_affichee > endurence) endurence_affichee --;


            if (endurence != endurence_affichee)
            {
                endurence_visible = true;
            } else if (temps_endurence == -1 && endurence_visible)
            {
                temps_endurence = temps_global;
            } else if ((temps_global - temps_endurence > DUREE_AFFICHAGE_ENDURENCE * IMAGES_PAR_SECONDE) && endurence_visible)
            {
                temps_endurence = -1;
                endurence_visible = false;
            }
        } else if (image.animation_finie()) // si le joueur est morte et que son animation de mort est finie
        {
            x_mort = position.x;
            y_mort = position.y;
            terminer_jeu();
        }
    }

    void afficher()
    {
        if (!visible)
        {
            return;
        }

        // décalage de l'ombre quand le joueur est mort car le sprite est plus large
        int ombre_decalage = 0;
        if (image.animation == ANIMATION_TOMATE_MORT && image.index_image > 6)
        {
            ombre_decalage = 1;
        }

        // affichage de l'ombre du joueur
        ecran.fill(color(0, 0, 0, 30));
        ecran.noStroke();
        ecran.ellipse(position.x + image.largeur / 2 - ombre_decalage, position.y + image.hauteur - ombre_decalage, image.largeur - 7, image.hauteur / 2 - 5); 

        // la jauge d'endurence clignote quand le joueur est épuisé
        if (epuise)
        {
            if (temps_global % (int) (IMAGES_PAR_SECONDE / 12) == 0)
            {
                afficher_endurence = !afficher_endurence;
            }

            endurence_visible = true;
        } else
        {
            afficher_endurence = true;
        }

        afficher_barre_endurence();   

        super.afficher();
    }


    void afficher_barre_endurence()
    {
        if (!afficher_endurence) return;

        if (endurence_visible)
        {
            opacite_endurence = min(255, opacite_endurence + 10);
        } else
        {
            opacite_endurence = max(0, opacite_endurence - 10);
        }

        ecran.fill(color(100, 100, 100, opacite_endurence));
        ecran.rect(position.x + image.largeur * (endurence_affichee / ENDURENCE_MAX), position.y - 5, image.largeur - image.largeur * (endurence_affichee / ENDURENCE_MAX), 3);

        ecran.fill(color(100, 100, 255, opacite_endurence));
        ecran.rect(position.x, position.y - 5, image.largeur * (endurence_affichee / ENDURENCE_MAX), 3);
    }


    void perdu()
    {
        trembler(80, 0.2, true);
        perdu = true;
        vitesse = new Vecteur(0, 0);
        image = new Image(IMAGE_TOMATE_MORT, 12, 0.6, ANIMATION_TOMATE_MORT, false);
        son_sprouitch.trigger();
        son_game_over.trigger();
    }
}

class FantomeJoueur extends Entite
{
    FantomeJoueur(Vecteur pos, Image img, boolean mx)
    {
        super(pos, img);
        vitesse = new Vecteur(0, 0);
        image.miroir_x = mx;
    }

    void mettre_a_jour()
    {
        image.opacite(image.opacite - 20);

        if (image.opacite < 0) detruire();
    }

    void afficher()
    {
        if (!(position.x < 0 || position.x > 218 - image.largeur / 2 || position.y > HAUTEUR_ECRAN - image.hauteur - 10 || position.y < 37))
        {
            super.afficher();
        }
    }
}