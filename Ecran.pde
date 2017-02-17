/* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
 *   Furious Tomato - Par Benjamin Strabach, Valentin Galerne et Simon Rozec   *
 *                                                                             *
 *                          ~ Initialisation de l'écran ~                      *
 * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * */

void initialiser_ecran()
{
  ecran = createGraphics(LARGEUR_ECRAN, HAUTEUR_ECRAN);
}



class Tremblement
{
	float amplitude;
	float duree;
	float temps;
	boolean decrementer;

	float multiplieur = 1;

	Tremblement(float a, float d, boolean dec)
	{
    	amplitude = a;
    	duree = d;
    	decrementer = dec;
    
		temps = 0;
    
    	if(dec)
    	{
        	multiplieur = exp((log(1/a)-10)/(d * IMAGES_PAR_SECONDE));
    	}
	}

	void mettre_a_jour()
	{
    	if(decrementer) amplitude *= multiplieur;
    	temps++;
		
		println(multiplieur);

		if(temps < duree * IMAGES_PAR_SECONDE)
		{
    		float moitie_amp = amplitude / 2;
    		translate(random(-moitie_amp, moitie_amp), random(-moitie_amp, moitie_amp));
		}
	}
}


void trembler(float amp, float duree, boolean decrementation)
{
    tremblement = new Tremblement(amp, duree, decrementation); 
}


Tremblement initialiser_tremblement()
{
	return new Tremblement(0, 0, false);   
}