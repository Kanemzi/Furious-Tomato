/* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
 *   Furious Tomato - Par Benjamin Strabach, Valentin Galerne et Simon Rozec   *
 *                                                                             *
 *                        ~ Transition entre les écrans ~                      *
 * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * */
 
class Transition
{
	final float duree_transition = (DUREE_TRANSITION * IMAGES_PAR_SECONDE);
    
    int temps_transition;
	boolean visible;	

	boolean demi_transition;
	boolean fin_transition;
	
	boolean peut_recommencer;
	
	float l;


	void lancer()
	{
    	if(!peut_recommencer)
    		return;
    	
    	visible = true;
    	demi_transition = false;
    	fin_transition = false;
    	peut_recommencer = false;
    	rembobiner();
	}

	void mettre_a_jour()
	{
    	float pourcentage_transition = ( (float) temps_transition / duree_transition);
    
    	demi_transition = temps_transition >= duree_transition / 2;
		fin_transition = temps_transition >= duree_transition;

		if(visible && !fin_transition)
		{
    		println(demi_transition);
    	
    		if(!demi_transition)
    		{
				l = f(pourcentage_transition) * LARGEUR_ECRAN;		
    		}
    		else
    		{
        		l = f( 1 - pourcentage_transition) * LARGEUR_ECRAN;
        	}
        
        	temps_transition ++;
		}
		else
		{
    		fin();
		}
	}
	
	float f(float x)
	{
    	return x * 2;
	}

	void afficher()
	{
    	if(visible)
    	{
        	ecran.fill(0);
        
        	ecran.beginShape(QUADS);
            ecran.vertex(0, 0);
            ecran.vertex(0, HAUTEUR_ECRAN);
            ecran.vertex(l - 40, HAUTEUR_ECRAN);
            ecran.vertex(l + 40, 0);
            
            ecran.vertex(LARGEUR_ECRAN, 0);
            ecran.vertex(LARGEUR_ECRAN, HAUTEUR_ECRAN);
            ecran.vertex(LARGEUR_ECRAN - l - 40, HAUTEUR_ECRAN);
            ecran.vertex(LARGEUR_ECRAN - l + 40, 0);
            ecran.endShape();
    	}
	}
	
	void fin()
	{
    	visible = false;
    	peut_recommencer = true;
	}
	
	void rembobiner()
	{
    	temps_transition = 0;
	}
	
	boolean finie()
	{
    	return fin_transition;
	}

	boolean demi_transition_passee()
	{
    	return demi_transition;
	}
}