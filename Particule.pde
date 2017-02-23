/* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
 *   Furious Tomato - Par Benjamin Strabach, Valentin Galerne et Simon Rozec   *
 *                                                                             *
 *                   ~ Fichier de description des particule ~                  *
 * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * */
 
class Particule extends Entite
{
    float temps_vie;
    color couleur;
    int rayon;
    
	Particule(Vecteur position, Vecteur vitesse, Vecteur acceleration, color c, float temps_vie, int rayon)
    {
        super(position, new Image(createImage(1, 1, RGB)));
        couleur = c;
        this.temps_vie = temps_vie * IMAGES_PAR_SECONDE;
        this.rayon = rayon;
        
        this.vitesse = vitesse;
        this.acceleration = acceleration;
    }
    
    void mettre_a_jour()
    {
        this.position.ajouter(vitesse);
        this.vitesse.multiplier(acceleration);

        image.mettre_a_jour();

        if (morte)
        {
            entites.remove(this);
        }
        
        if(temps_vie-- <= 0)
        {
            morte = true;   
        }
    }
    
    void afficher(PGraphics g)
    {
        g.noStroke();
    	g.fill(couleur);
    	g.ellipse(position.x, position.y, rayon, rayon);
    
    	if(afficher_collision)
        {
        	g.fill(color(255, 100, 100, 160));
            g.ellipse(position.x + decalage_collision.x , position.y + decalage_collision.y, rayon_collision, rayon_collision);
        }
    }
}


/* Particule utilisée quand le joueur est épuisé */
class GoutteEau extends Particule
{
    GoutteEau(Vecteur pos)
    {
        super(pos, new Vecteur(random(-2.5, 2.5), random(-1.5, -2)), new Vecteur(0, random(0.1, 0.5)), color(100, 100, 255), random(0.1, 0.3), 2);
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
        
        if(temps_vie-- <= 0)
        {
            morte = true;   
        }
    }
}