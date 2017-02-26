/* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
 *   Furious Tomato - Par Benjamin Strabach, Valentin Galerne et Simon Rozec   *
 *                                                                             *
 *                      ~ Fichier de gestion des couteaux ~                    *
 * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * */

ArrayList<Couteau> couteaux = new ArrayList<Couteau>(); // liste des couteaux affichés à l'écran

class Couteau extends Entite
{
    float vieCouteau;
	Vecteur position_cible; // sauvegarde de la position cible (pour le clonage)	

    Couteau(Vecteur position, Vecteur positionCible)
    {
        super(position, new Image(IMAGE_COUTEAU));
        parametrer_collision(image.hauteur * 1.5, new Vecteur(0, 0), AFFICHER_COLLISIONS);

        image.origine(image.largeur/2, image.hauteur/2);
        image.angle(random(0, TWO_PI));
        float a = angle_entre(position.x, position.y, positionCible.x, positionCible.y);
        vitesse.modifierAL(a, 1.6);

        vieCouteau = 10 * IMAGES_PAR_SECONDE;
        
        position_cible = positionCible;
    }


    void mettre_a_jour()
    {
        super.mettre_a_jour();
        image.angle(image.angle + PI/10);
        decalage_collision.x = -cos(image.angle) * (image.largeur / 4);
        decalage_collision.y = -sin(image.angle) * (image.largeur / 4);

        vieCouteau --;
        
        boolean sortie_ecran = (position.x < -64) || (position.x > LARGEUR_PLANCHE + 64) || (position.y < HAUTEUR_BANDEAU - 64 ) || (position.y > HAUTEUR_ECRAN + 64);
        
        if ( vieCouteau <= 0 || sortie_ecran)
        {
            morte = true;
        }
    }
    
    
    void detruire()
    {
        couteaux.remove(this);
    }


    void collision(Joueur j)
    {
        if (!super.collision(j)) 
            return;

        if (!j.impulsion && !j.perdu) 
        {
            j.perdu();

            for (int i = 0; i < 50; i++)
            {
                boolean pepin = (int) random(7) == 0;

                Vecteur v;
                if (random(10) < 4)
                {
                    v = new Vecteur(random(-6, 6), random(-3, 3));
                }
                else
                {
                    v = new Vecteur(0, 0);
                    v.modifierAL(vitesse.direction() + random(-PI/20, PI/20), vitesse.longueur() + random(4, 20));
                }

                entites.add(0, new Particule(new Vecteur(position.x + decalage_collision.x, position.y + decalage_collision.y), 
                    v, 
                    new Vecteur(random(0.2, 0.8), random(0.2, 0.8)), 
                    (pepin) ? #E28F41 : #C64617, 
                    random(1, 2), (pepin) ? 2 : (int) random(2, 4)
                ));
            }
        }
    }
}


class GenerateurCouteau 
{
    float intervalleCouteau;
    float temps;
    
    GenerateurCouteau()
    {
        intervalleCouteau = 1.6 * IMAGES_PAR_SECONDE;
        temps = intervalleCouteau / 2;
    }


    void mettre_a_jour()
    {
        temps--;
        
        if (temps <= 0)
        {
            couteaux.add(new Couteau(genererPosition(), genererCible()));
            temps = intervalleCouteau;
        }
    }


    Vecteur genererPosition()
    {
        Vecteur v = new Vecteur(0, 0);
        if ( random(100) > 50 )
        {
            v.x = random(LARGEUR_PLANCHE);
            
            if ( random(100) > 50 )
            {
                v.y = HAUTEUR_BANDEAU - 16;
            }
            else
            {
                v.y = HAUTEUR_ECRAN + 16;
            }
        }
        else
        {
            v.y = random(HAUTEUR_BANDEAU, HAUTEUR_ECRAN);
            
            if ( random(100) > 50 )
            {
                v.x = - 16;
            }
            else
            {
                v.x = LARGEUR_PLANCHE + 16;
            }
        }
        return v;
    }


    Vecteur genererCible()
    {
        Vecteur v = new Vecteur(0, 0);
        if ( (int) random(2) == 0)
        {
            v.x = joueur.position.x + joueur.decalage_collision.x + random(-64, 64);
            v.y = joueur.position.y + joueur.decalage_collision.y + random(-64, 64);
        }
        else
        {
            v.x = random(LARGEUR_PLANCHE);
            v.y = random(HAUTEUR_BANDEAU, HAUTEUR_ECRAN);
        }

        return v;
    }
}