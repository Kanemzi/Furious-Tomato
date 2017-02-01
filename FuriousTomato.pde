/* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
 *   Furious Tomato - Par Benjamin Strabach, Valentin Galerne et Simon Rozec   *
 *                                                                             *
 *                             ~ Fichier principal ~                           *
 * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * */

String ecran;
int temps_global;

void settings()
{
	switch(ECHELLE)
	{	
    	case 1:
    		size(320, 180);
    		break;	
    	
    	case 2:
    		size(640, 360);
			break;
		
		case 3:
            size(960, 540);   
            break;
            
		case 4:
			size(1280, 720);
			break;
	}

	noSmooth();
}

Joueur j;

void setup()
{
	frameRate(IMAGES_PAR_SECONDE);

	temps_global = 0;
	ecran = ECRANS[MENU];
	
	j = new Joueur(new Vecteur(64, 64));
}



void draw()
{
	temps_global ++;

	surface.setTitle(""+(int) frameRate);
	
	pushMatrix();
    scale(ECHELLE, ECHELLE);

	if(ecran == ECRANS[INTRO])
	{
    	if(!intro_init)
    	{
        	intro_init = true;
        	initialiser_intro();
    	}
    	mettre_a_jour_intro();
		dessiner_intro();
	} 
	else if (ecran == ECRANS[MENU])
	{
    	fill(#FFFF00);
        rect(0, 0, LARGEUR_ECRAN, HAUTEUR_ECRAN);
    	j.mettre_a_jour();
    	j.afficher();
		
	}
	else if(ecran == ECRANS[CREDITS])
	{
    	if(!credits_init)
        {
            credits_init = true;
            initialiser_credits();
        }
        mettre_a_jour_credits();
        dessiner_credits();
	}
  
	popMatrix();
}