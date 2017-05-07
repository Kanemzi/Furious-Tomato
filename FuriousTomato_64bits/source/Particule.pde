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

     	if(temps_vie-- <= 0)
        {
            detruire();   
        }
    }
    
    void afficher()
    {
        //g.noStroke();
    	ecran.fill(couleur);
    	ecran.ellipse(position.x, position.y, rayon, rayon);
    
    	if(afficher_collision)
        {
        	ecran.fill(color(255, 100, 100, 160));
            ecran.ellipse(position.x + decalage_collision.x , position.y + decalage_collision.y, rayon_collision, rayon_collision);
        }
    }
}


/* Particule utilisée quand le joueur est épuisé */
class GoutteEau extends Particule
{
    GoutteEau(Vecteur pos)
    {
        super(pos, new Vecteur(random(-1.5, 1.5), random(-1.5, -2)), new Vecteur(0, random(0.1, 0.5)), color(100, 100, 255), random(0.1, 0.3), 2);
    }
    
    void mettre_a_jour()
    {
        this.position.ajouter(vitesse);
        this.vitesse.ajouter(acceleration);

        if(temps_vie-- <= 0)
        {
            detruire();
        }
    }
}


class Etincelle extends Particule
{
    boolean eteinte = false;
    
    Etincelle(Vecteur pos, int col, float vie)
    {
        super(pos, new Vecteur(0, 0), new Vecteur(random(0.65, 0.8), 0), col, vie + random(1), (int) random(1, 3));
        vitesse.modifierAL(random(TWO_PI), 7);
    }
    
    void mettre_a_jour()
    {
        this.position.ajouter(vitesse);
        this.vitesse.multiplier(acceleration.x);
		
		acceleration.x += 0.04;
		if(acceleration.x >= 1) acceleration.x = 1;

        if(temps_vie-- <= 0)
        {
            eteinte = true;
        }
    }
}

class FeuArtifice
{
    final int[] couleurs = {#e74c3c, #e67e22, #ffc40f, #2ecc71, #1abc9c, #3498db, #9b59b6};
    
    ArrayList<Etincelle> ets;
    
    Vecteur pos;
    
	int nbParts;
	
 	FeuArtifice(Vecteur pos, float taille, int nbParts)
 	{
    	int cindex = (int) random(7);
    	
    	this.nbParts = nbParts;
    
    	ets = new ArrayList<Etincelle>();
    	for(int i = 0; i < nbParts; i++)
    	{
        	int ind = cindex + (int) random(0, 2);
        	if(ind > 6) ind = 0;
        
        	ets.add(new Etincelle(pos.copie(), couleurs[ind], taille));
        	
    	}
 	}
 
 	void afficher()
	{
    	for(Etincelle e : ets)
    	{
        	e.mettre_a_jour();
        	if(!e.eteinte) e.afficher();
        }
	}
}