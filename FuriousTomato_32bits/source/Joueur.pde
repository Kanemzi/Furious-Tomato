/* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
 *   Furious Tomato - Par Benjamin Strabach, Valentin Galerne et Simon Rozec   *
 *                                                                             *
 *                        ~ Fichier de gestion du joueur ~                     *
 * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * */

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

    float endurance;
    float endurance_affichee;
    float opacite_endurance;
    int temps_endurance;
    boolean endurance_visible;
    boolean afficher_endurance; // pareil qu'endurance_visible mais en tout ou rien (ignore le fade)
    boolean endurance_regeneration = false;


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

        endurance = ENDURENCE_MAX;
        endurance_affichee = endurance;
        opacite_endurance = 2;
        endurance_visible = true;
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
                    endurance -= DIFF_cout_endurance_impulsion;
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
                endurance_regeneration = true;
            } else
            {
                endurance_regeneration = false;
            }

            if (endurance_regeneration && temps_global % 2 == 0)
            {
                endurance += 2;
            }


            // gestion de l'épuisement du joueur
            if (endurance <= 0)
            {
                epuise = true;
            }

            if (epuise && endurance >= ENDURENCE_MAX / 2)
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


            endurance = max(0, endurance);
            endurance = min(ENDURENCE_MAX, endurance);
            
            // variation progressive de l'endurance affichée
            if (endurance_affichee < endurance) endurance_affichee ++;
            if (endurance_affichee > endurance) endurance_affichee --;

            if (endurance != endurance_affichee)
            {
                endurance_visible = true;
            }
            else if (temps_endurance == -1 && endurance_visible)
            {
                temps_endurance = temps_global;
            }
            else if ((temps_global - temps_endurance > DUREE_AFFICHAGE_ENDURENCE * IMAGES_PAR_SECONDE) 
                         && endurance_visible)
            {
                temps_endurance = -1;
                endurance_visible = false;
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

        // la jauge d'endurance clignote quand le joueur est épuisé
        if (epuise)
        {
            if (temps_global % (int) (IMAGES_PAR_SECONDE / 12) == 0)
            {
                afficher_endurance = !afficher_endurance;
            }

            endurance_visible = true;
        } else
        {
            afficher_endurance = true;
        }

        afficher_barre_endurance();   

        super.afficher();
    }


    void afficher_barre_endurance()
    {
        if (!afficher_endurance) return;

        if (endurance_visible)
        {
            opacite_endurance = min(255, opacite_endurance + 10);
        } else
        {
            opacite_endurance = max(0, opacite_endurance - 10);
        }

        ecran.fill(color(100, 100, 100, opacite_endurance));
        ecran.rect(position.x + image.largeur * (endurance_affichee / ENDURENCE_MAX), 
                   position.y - 5, 
                   image.largeur - image.largeur * (endurance_affichee / ENDURENCE_MAX), 
                   3
                  );

        ecran.fill(color(100, 100, 255, opacite_endurance));
        ecran.rect(position.x, 
                   position.y - 5, 
                   image.largeur * (endurance_affichee / ENDURENCE_MAX),
                   3
                  );
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