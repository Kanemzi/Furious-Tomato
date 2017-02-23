/* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
 *   Furious Tomato - Par Benjamin Strabach, Valentin Galerne et Simon Rozec   *
 *                                                                             *
 *                      ~ Fichier de gestion des couteaux ~                    *
 * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * */

class Couteau extends Entite
{
    float vieCouteau;
    Couteau(Vecteur position, Vecteur positionCible)
    {
        super(position, new Image(IMAGE_COUTEAU));
        parametrer_collision(image.hauteur, new Vecteur(0, 0), AFFICHER_COLLISIONS);
        
        image.origine(image.largeur/2, image.hauteur/2);
        image.angle(random(0, TWO_PI));
        float a = angle_entre(position.x, position.y, positionCible.x, positionCible.y);
        vitesse.modifierAL(a, 1.8);
        vieCouteau = 5 * IMAGES_PAR_SECONDE;
    }

    void mettre_a_jour()
    {
        super.mettre_a_jour();
        image.angle(image.angle + PI/10);
        decalage_collision.x = -cos(image.angle) * (image.largeur / 4);
		decalage_collision.y = -sin(image.angle) * (image.largeur / 4);

        vieCouteau --;
        if ( vieCouteau <= 0 )
        {
            morte = true;
        }
    }
    
    
    void collision(Joueur j)
    {
    	if(!super.collision(j)) 
    		return;
    	
    	if(!j.impulsion && !j.perdu) 
    	{
        	j.perdu();
    		
    		for(int i = 0; i < 50; i++)
        	{
                boolean pepin = (int) random(7) == 0;
                
                Vecteur v;
                if(random(10) < 4)
                {
                    v = new Vecteur(random(-10, 10), random(-5, 5));
                }
                else
                {
                	v = new Vecteur(0, 0);
                	v.modifierAL(vitesse.direction() + random(-PI/20, PI/20), random(6, 20));
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
        intervalleCouteau = 1.5 * IMAGES_PAR_SECONDE;
        temps = intervalleCouteau;
    }

    void mettre_a_jour()
    {
        temps--;
        if ( temps <= 0)
        {
            entites.add(new Couteau(genererPosition(), genererCible()));
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
                v.y = HAUTEUR_ECRAN-HAUTEUR_PLANCHE - 16;
            } else
            {
                v.y = HAUTEUR_ECRAN + 16;
            }
        }
        else
        {
            v.y = random(HAUTEUR_ECRAN-HAUTEUR_PLANCHE, HAUTEUR_ECRAN);
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
        if( (int) random(4) == 0)
        {
            v.x = joueur.position.x + joueur.decalage_collision.x;
            v.y = joueur.position.y + joueur.decalage_collision.y;
        }
        else
        {
        	v.x = random(LARGEUR_PLANCHE);
        	v.y = random(HAUTEUR_ECRAN-HAUTEUR_PLANCHE, HAUTEUR_ECRAN);
        }
        
        return v;
    }
}