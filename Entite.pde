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
    	return dist(position.x + decalage_collision.x, position.y + decalage_collision.y, e.position.x + e.decalage_collision.x, e.position.y + e.decalage_collision.y) < rayon_collision + e.rayon_collision;
    }


    void afficher()
    {
        if (visible)
        {
            image.afficher(position.x, position.y);
			
			if(afficher_collision)
            {
    			ecran.fill(color(255, 100, 100, 160));
    			ecran.ellipse(position.x + decalage_collision.x , position.y + decalage_collision.y, rayon_collision, rayon_collision);
			}
    	}
    }
}