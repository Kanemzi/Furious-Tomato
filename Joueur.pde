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
    final float COUT_IMPULSION_ENDURENCE = ENDURENCE_MAX / 5;
    
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
    
    boolean ralenti = false;

	float axeX = 0; // dose de déplacement en X : -1 < x < 1
	float axeY = 0; // dose de déplacement en Y : -1 < y < 1

    Joueur(Vecteur pos)
    {
        super(pos, new Image(IMAGE_TOMATE, 20, 0.2, ANIMATION_TOMATE_PROFIL_FACE, true));
        parametrer_collision(image.largeur / 1.8, new Vecteur(image.largeur / 2, 2*image.hauteur / 3), AFFICHER_COLLISIONS);
        perdu = false;
        
        endurence = ENDURENCE_MAX;
        endurence_affichee = endurence;
        opacite_endurence = 0;
        endurence_visible = false;
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
            }
            else
            {
                if(impulsion)
                {
                	vit_dep = VIT_DEP_IMPULSION; 
                }
                else if(ralenti)
                {
                    vit_dep = VIT_DEP_RALENTI;
                }
                else
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
			if(touches[TOUCHE_IMPULSION])
			{
    			if(impulsion)
    			{
        			entites.add(new FantomeJoueur(new Vecteur(position.x + vitesse.x, position.y + vitesse.y), new Image(image.actuelle()), image.miroir_x));
        
        			if(temps_global - temps_debut_impulsion > DUREE_IMPULSION * IMAGES_PAR_SECONDE)
        			{
            			impulsion = false;
            		}
    			}
    			else if(impulsion_disponible)
    			{
        			impulsion = true;
        			impulsion_disponible = false;
        			temps_debut_impulsion = temps_global;
        			endurence -= COUT_IMPULSION_ENDURENCE;
        		}
			}
			else
			{
    			impulsion = false;
    			impulsion_disponible = true;
    		}
			

			
			// Gestion de l'animation du joueur

            image.miroir_x = angle > 0 && angle < PI;

            if (angle == 0) // le personnage va vers le bas
            {
                image.changerAnimation(ANIMATION_TOMATE_FACE, 0.2, false, false, true);
            }
            else if (angle == -PI/2 || angle == -PI/4 || angle == PI/2 || angle == PI/4)  // le personnage va vers le bas en diagonale
            {
                image.changerAnimation(ANIMATION_TOMATE_PROFIL_FACE, 0.2, false, false, true);
            }
            else if (angle == PI)  // le personnage va vers le haut 
            {
                image.changerAnimation(ANIMATION_TOMATE_DOS, 0.2, false, false, true);
            }
            else if (angle == -3*PI/4 || angle == 3*PI/4)  // le personnage va vers le haut en diagonale
            {
                image.changerAnimation(ANIMATION_TOMATE_PROFIL_DOS, 0.2, false, false, true);
            }
            
            if (vitesse.longueur() == 0)
            {
                image.changerVitesseAnimation(0);
                image.index_image = 0;
            }
            else 
            {
                image.changerVitesseAnimation(0.2);
            }
            
            /*
            if (touches[ENTER] && touche_pressee)
            {
                endurence_visible = !endurence_visible;
            }
            */
            if (touches[CONTROL]  && touche_pressee)
            {
                endurence -= 20;
            }
             if (touches[SHIFT]  && touche_pressee)
            {
                endurence += 20;
            }
            
            endurence = max(0, endurence);
            endurence = min(ENDURENCE_MAX, endurence);
            
            if(endurence_affichee < endurence) endurence_affichee ++;
            if(endurence_affichee > endurence) endurence_affichee --;
            
            
            if(endurence != endurence_affichee)
            {
            	endurence_visible = true;
            	
            }
            else if(temps_endurence == -1 && endurence_visible)
            {
                temps_endurence = temps_global;
            }
            else if((temps_global - temps_endurence > DUREE_AFFICHAGE_ENDURENCE * IMAGES_PAR_SECONDE) && endurence_visible)
            {
                temps_endurence = -1;
            	endurence_visible = false;
            }
		}
        else if (image.animation_finie()) // si le joueur est morte et que son animation de mort est finie
        {
            x_mort = position.x;
            y_mort = position.y;
            terminer_jeu();
        }
    }

    void afficher(PGraphics g)
    {
        if(!visible) return;
        
        int ombre_decalage = 0;
        if(image.animation == ANIMATION_TOMATE_MORT && image.index_image > 6)
        {
        	   ombre_decalage = 1;
        }
        
        g.fill(color(0, 0, 0, 30));
        g.noStroke();
        g.ellipse(position.x + image.largeur / 2 - ombre_decalage, position.y + image.hauteur - ombre_decalage , image.largeur - 7, image.hauteur / 2 - 5); // dessin de l'ombre
        
        
        
        if(endurence_visible)
        {
        	opacite_endurence = min(255, opacite_endurence + 10);   
        }
        else
        {
        	opacite_endurence = max(0, opacite_endurence - 10);  
        }
        
        g.fill(color(100, 100, 100, opacite_endurence));
        g.rect(position.x + image.largeur * (endurence_affichee / ENDURENCE_MAX), position.y - 5, image.largeur - image.largeur * (endurence_affichee / ENDURENCE_MAX), 3);
        
        g.fill(color(100, 100, 255, opacite_endurence));
        g.rect(position.x, position.y - 5, image.largeur * (endurence_affichee / ENDURENCE_MAX), 3);
        
        
        
        super.afficher(ecran);
    }
    
    void perdu()
    {
        trembler(80, 0.2, true);
        perdu = true;
        vitesse = new Vecteur(0, 0);
        image = new Image(IMAGE_TOMATE_MORT, 12, 0.6, ANIMATION_TOMATE_MORT, false);
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
    
    	if (image.opacite < 0 || position.x < 0 || position.x > 218 - image.largeur / 2 || position.y > HAUTEUR_ECRAN - image.hauteur - 10 || position.y < 37) morte = true;
    }
}