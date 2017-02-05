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

Image imge;



void setup()
{
	frameRate(IMAGES_PAR_SECONDE);

	temps_global = 0;
	scene = SCENES[MENU];
	
	initialiser_ecran();
	initialiser_police();
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
    	if(!menu_init)
        {
            menu_init = true;
            initialiser_menu();
        }
        mettre_a_jour_menu();
        dessiner_menu();
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
	else if(scene == SCENES[JEU])
	{
    	if(!jeu_init)
        {
            jeu_init = true;
            initialiser_jeu();
        }
        mettre_a_jour_jeu();
        dessiner_jeu();
	}
  	
  	ecran.endDraw();
  
  	pushMatrix();
    scale(ECHELLE, ECHELLE);
  	image(ecran, 0, 0);
  	popMatrix();

	mettre_a_jour_entrees();
}