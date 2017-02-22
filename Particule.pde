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
    
    void afficher()
    {
    	ecran.fill(couleur);
    	ecran.ellipse(position.x, position.y, rayon, rayon);
    
    	if(afficher_collision)
        {
        	ecran.fill(color(255, 100, 100, 160));
            ecran.ellipse(position.x + decalage_collision.x , position.y + decalage_collision.y, rayon_collision, rayon_collision);
        }
    }
}