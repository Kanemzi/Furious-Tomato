/* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
 *   Furious Tomato - Par Benjamin Strabach, Valentin Galerne et Simon Rozec   *
 *                                                                             *
 *                             ~ Fichier principal ~                           *
 * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * */

String scene;
int temps_global;
PGraphics ecran;

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
	scene = SCENES[CREDITS];
	
	initialiser_ecran();
	initialiser_police();
	
	j = new Joueur(new Vecteur(64, 64));
}



void draw()
{
	temps_global ++;

	surface.setTitle(""+(int) frameRate);
	
	ecran.beginDraw();

	if(scene == SCENES[INTRO])
	{
    	if(!intro_init)
    	{
        	intro_init = true;
        	initialiser_intro();
    	}
    	mettre_a_jour_intro();
		dessiner_intro();
	} 
	else if (scene == SCENES[MENU])
	{
    	fill(#FFFF00);
        rect(0, 0, LARGEUR_ECRAN, HAUTEUR_ECRAN);
    	j.mettre_a_jour();
    	j.afficher();
	}
	else if(scene == SCENES[CREDITS])
	{
    	if(!credits_init)
        {
            credits_init = true;
            initialiser_credits();
        }
        mettre_a_jour_credits();
        dessiner_credits();
	}
  	
  	ecran.endDraw();	
  
  	pushMatrix();
    scale(ECHELLE, ECHELLE);
  	image(ecran, 0, 0);
	popMatrix();
}