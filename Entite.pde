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


	Entite(Vecteur position, Image image)
	{
		this.position = position;
		vitesse = new Vecteur(0, 0);
		acceleration = new Vecteur(0, 0);
		
		this.image = image;
	
		morte = false;
		visible = true;
	}


	void mettre_a_jour()
	{
		this.position.ajouter(vitesse);
		this.vitesse.ajouter(acceleration);
    
    	image.mettre_a_jour();
    
		if(morte)
		{
    		entites.remove(this);
		}
	}


	void afficher()
	{
    	if(visible)
    	{
        	image.afficher(position.x, position.y);
    	}
	}
}