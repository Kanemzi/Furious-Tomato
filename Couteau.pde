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
        image.origine(image.largeur/2, image.hauteur/2);
        image.angle(random(0, TWO_PI));
        float a = angle_entre(position.x, position.y, positionCible.x, positionCible.y);
        vitesse.modifierAL(a, 3);
        vieCouteau = 5 * IMAGES_PAR_SECONDE;
    }

    void mettre_a_jour()
    {
        super.mettre_a_jour();
        image.angle(image.angle + PI/10);
        vieCouteau --;
        if ( vieCouteau <= 0 )
        {
            morte = true;
        }
    }
}


class GenerateurCouteau 
{
    float intervalleCouteau;
    float temps;

    GenerateurCouteau()
    {
        intervalleCouteau = 1 * IMAGES_PAR_SECONDE;
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
        v.x = random(LARGEUR_PLANCHE);
        v.y = random(HAUTEUR_ECRAN-HAUTEUR_PLANCHE, HAUTEUR_ECRAN);
        return v;
    }
}