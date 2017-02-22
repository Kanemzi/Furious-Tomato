/* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
 *   Furious Tomato - Par Benjamin Strabach, Valentin Galerne et Simon Rozec   *
 *                                                                             *
 *                         ~ Fichier de gestion du sel ~                       *
 * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * */
 
class Sel extends Particule
{
    float y_cible;
    
	Sel(Vecteur position, Vecteur vitesse, Vecteur acceleration, float y_cible, float temps_vie)
	{
    	super(position, vitesse, acceleration, #FFFFFF, temps_vie, 2);
    	parametrer_collision(4, new Vecteur(0, 0), AFFICHER_COLLISIONS);
    	this.y_cible = y_cible;
	}
	
	void mettre_a_jour()
	{
    	super.mettre_a_jour();
    
    	if(position.y >= y_cible)
    	{
        	vitesse.x = 0;
        	vitesse.y = 0;
        
        	position.y = y_cible;
    	}
	}

	boolean collision(Joueur j)
    {
        if(!super.collision(j)) 
            return false;
    
        j.ralenti = true;
        return true;
    }
}


class Saliere extends Entite
{
	final float DUREE_SALIERE_ACTIVE = IMAGES_PAR_SECONDE * 5;

    final float DUREE_DISPARITION_MINIATURE = DUREE_SALIERE_ACTIVE * (1.0/10.0);
    final float DUREE_TEMPS_REACTION = DUREE_SALIERE_ACTIVE *        (2.5/10.0);
    final float DUREE_DESCENTE_SALIERE = DUREE_SALIERE_ACTIVE *      (0.5/10.0);
    final float DUREE_SEL_TOMBE = DUREE_SALIERE_ACTIVE *             (5.0/10.0);
    final float DUREE_MONTEE_SALIERE = DUREE_SALIERE_ACTIVE *        (0.5/10.0);
    final float DUREE_DESCENTE_MINIATURE = DUREE_SALIERE_ACTIVE *    (0.5/10.0);
    
    final float TEMPS_DISPARITION_MINIATURE = 0.0;
    final float TEMPS_ATTENTE = DUREE_DISPARITION_MINIATURE;
    final float TEMPS_DESCENTE_SALIERE = TEMPS_ATTENTE + DUREE_TEMPS_REACTION;
    final float TEMPS_SEL_TOMBE = TEMPS_DESCENTE_SALIERE + DUREE_DESCENTE_SALIERE;
    final float TEMPS_MONTEE_SALIERE = TEMPS_SEL_TOMBE + DUREE_SEL_TOMBE;
    final float TEMPS_DESCENTE_MINIATURE = TEMPS_MONTEE_SALIERE + DUREE_MONTEE_SALIERE;
    
    final float MINIATURE_Y_MAX = 29;
    final float SALIERE_ACTIVE_Y = (HAUTEUR_ECRAN - HAUTEUR_PLANCHE) / 2;
    
    Image miniature;
    Vecteur position_miniature;
    
    boolean activee;
    int temps_activation;
    int delais_activation;
    
    Vecteur position_zone;
    Vecteur taille_zone;
    
	Saliere()
	{
    	super(new Vecteur(0, 0), new Image(IMAGE_SALIERE));
    	image.origine(image.largeur/2, image.hauteur/3);
    	activee = false;
    	temps_activation = -1;
    	
    	miniature = new Image(IMAGE_SALIERE_MINI);
    	position_miniature = new Vecteur(103, 29);
    	
    	position_zone = new Vecteur(0, 0);
    	taille_zone = new Vecteur(0, 0);
    
    	desactiver();
	}
    
    void activer(Vecteur position_zone, Vecteur taille_zone)
    {
    	activee = true;
        temps_activation = temps_global;
        this.position_zone = position_zone;
        this.taille_zone = taille_zone;
    }
    
    void desactiver()
    {
        activee = false;
        temps_activation = -1;
        delais_activation = (int)IMAGES_PAR_SECONDE * (int)random(9, 16);
	}
    
    void mettre_a_jour()
    {
        super.mettre_a_jour();
        
    	if(activee)
    	{
        	float pourcentage_avancement;
        
        	float duree_active = temps_global - temps_activation;
        
        	if(duree_active > DUREE_SALIERE_ACTIVE)
            {
                desactiver();
            }
        	else if(duree_active > TEMPS_DESCENTE_MINIATURE)
        	{
            	pourcentage_avancement = (duree_active - TEMPS_DESCENTE_MINIATURE) / DUREE_DESCENTE_MINIATURE;
            	
    			position_miniature.y = - miniature.hauteur + pourcentage_avancement * (MINIATURE_Y_MAX + miniature.hauteur);
			}
        	else if(duree_active > TEMPS_MONTEE_SALIERE)
        	{
            	pourcentage_avancement = (duree_active - TEMPS_MONTEE_SALIERE) / DUREE_MONTEE_SALIERE;
            	
            	position.x = position_zone.x + taille_zone.x;
            	position.y = SALIERE_ACTIVE_Y - pourcentage_avancement * (SALIERE_ACTIVE_Y + image.hauteur);
        	}
        	else if(duree_active > TEMPS_SEL_TOMBE)
            {
                pourcentage_avancement = (duree_active - TEMPS_SEL_TOMBE) / DUREE_SEL_TOMBE;
                
				position.x = position_zone.x + fonctionDeplacementSaliere(pourcentage_avancement) * taille_zone.x;
                position.y = MINIATURE_Y_MAX + fonctionSecouerSaliere(pourcentage_avancement, 10);
                
                image.angle = fonctionInclinerSaliere(pourcentage_avancement, PI/8);
                
                if(position.y > MINIATURE_Y_MAX + 9) for(int g = 0; g < 5; g++) creerGrainSel(); // 5
                if(temps_global % 8 == 0) creerGrainSel(); // 2
            }
            else if(duree_active > TEMPS_DESCENTE_SALIERE)
            {
                pourcentage_avancement = (duree_active - TEMPS_DESCENTE_SALIERE) / DUREE_DESCENTE_SALIERE;
                
                position.x = position_zone.x;
                position.y = - image.hauteur + pourcentage_avancement * (SALIERE_ACTIVE_Y + image.hauteur);
            }
            else if(duree_active > TEMPS_ATTENTE)
            {
                pourcentage_avancement = (duree_active - TEMPS_ATTENTE) / DUREE_TEMPS_REACTION;
            }
            else if(duree_active > TEMPS_DISPARITION_MINIATURE)
            {
                position.x = - 100;
                position.y = - 100;
                
                pourcentage_avancement = (duree_active - TEMPS_DISPARITION_MINIATURE) / DUREE_DISPARITION_MINIATURE;
                
                position_miniature.y = MINIATURE_Y_MAX - pourcentage_avancement * (MINIATURE_Y_MAX + miniature.hauteur);
            }
    	}
    	else
    	{
        	if(--delais_activation == 0) 
        	{
            	final float BORDURE_PLANCHE = 10;
            	final float AREA = 48 * 48;
        		float largeur = random(32, 96);
        		Vecteur taille = new Vecteur(largeur, AREA / largeur);
        		Vecteur position = new Vecteur(random(BORDURE_PLANCHE, LARGEUR_PLANCHE - taille.x - BORDURE_PLANCHE) , random(HAUTEUR_ECRAN - HAUTEUR_PLANCHE + BORDURE_PLANCHE, HAUTEUR_ECRAN - taille.y - BORDURE_PLANCHE));    
        		activer(position, taille); 
    		}
    	}
    }
    
    void afficher()
    {
        miniature.afficher(position_miniature.x, position_miniature.y);

        if(activee)
    		super.afficher();   
    }
    
    
    float yprev = 0;
    
    void creerGrainSel()
    {
        entites.add(0, new Sel(
                new Vecteur(position.x + random(4) * 5 * sin(image.angle), position.y + image.hauteur + random(-4, 4)),
                new Vecteur(-sin(image.angle) * 5, 1),
                new Vecteur(.8, 1.4),
                random(position_zone.y, position_zone.y + taille_zone.y),
                random(4, 12)                
            ));
    }
 
    
    float fonctionDeplacementSaliere(float x)
    {
    	return (sin(x*3*PI-HALF_PI)) / 2 + .5;   
    }
    
    float fonctionSecouerSaliere(float x, float amplitude)
    {
        return sin(x*20*PI) * amplitude;
    }
    
    float fonctionInclinerSaliere(float x, float amplitude)
    {
        return sin(x*10*PI) * amplitude;
    }
    
}