/* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
 *   Furious Tomato - Par Benjamin Strabach, Valentin Galerne et Simon Rozec   *
 *                                                                             *
 *                    ~ Fichier de description des entités ~                   *
 * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * */

ArrayList<Entite> entites = new ArrayList<Entite>();

class Entite
{
    Vecteur position;
    Vecteur vitesse;
    Vecteur acceleration;

    Image image;

    boolean morte;
    boolean visible;

    float rayon_collision;
    Vecteur decalage_collision;
    boolean afficher_collision;

    Entite(Vecteur position, Image image)
    {
        this.position = position;
        vitesse = new Vecteur(0, 0);
        acceleration = new Vecteur(0, 0);

        this.image = image;

        morte = false;
        visible = true;
    }


    void detruire()
    {
        entites.remove(this);
    }


    void mettre_a_jour()
    {
        this.position.ajouter(vitesse);
        this.vitesse.ajouter(acceleration);

        image.mettre_a_jour();

        if (morte)
        {
            entites.remove(this);
        }
    }


    void parametrer_collision(float rayon, Vecteur decalage, boolean afficher)
    {
        rayon_collision = rayon;
        decalage_collision = decalage;
        afficher_collision = afficher;
    }


    boolean collision(Entite e)
    {
        return dist(position.x + decalage_collision.x, position.y + decalage_collision.y, e.position.x + e.decalage_collision.x, e.position.y + e.decalage_collision.y) < (rayon_collision + e.rayon_collision) * .5;
    }


    void afficher(PGraphics g)
    {
        if (visible)
        {
            image.afficher(position.x, position.y, g);

            if (afficher_collision)
            {
                int decalageCouteau = 0;
                if (this instanceof Couteau) decalageCouteau = -HAUTEUR_BANDEAU;
                
                g.noStroke();
                g.fill(color(255, 100, 100, 160));
                g.ellipse(position.x + decalage_collision.x, position.y + decalage_collision.y + decalageCouteau, rayon_collision, rayon_collision);
            }

            if (AFFICHER_MOUVEMENT) // affichage du vecteur vitesse et acceleration
            {
                g.stroke(#0000ff);
                g.line(position.x, position.y, position.x + vitesse.x * 10, position.y + vitesse.y * 10);
                g.stroke(#ff0000);
                g.line(position.x, position.y, position.x + acceleration.x * 100, position.y + acceleration.y * 100);
            }
        }
    }
}