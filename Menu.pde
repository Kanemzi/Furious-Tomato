/* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
 *   Furious Tomato - Par Benjamin Strabach, Valentin Galerne et Simon Rozec   *
 *                                                                             *
 *                     ~ Gestion de l'écran du menu du jeu ~                   *
 * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * */

// Boutons du menu
boolean menu_init = false;
MenuPrincipal menu;

boolean selection_active;

Image imageMenu;
Image imageCurseur;

// Animation du menu
int temps_menu;

final float couperet_y_debut = -200,
			couperet_y_fin = 23;

final float couperet_angle_debut = - PI / 2,
            couperet_angle_fin = 0;//- PI / 30;

float couperet_x, couperet_y;
float couperet_angle;
float amplitude_choc_couperet;

Image couperet;


void initialiser_menu()
{
    menu =  new MenuPrincipal();
    imageCurseur = new Image(IMAGE_CURSEUR);
    imageMenu = new Image(IMAGE_MENU);
    couperet = new Image(IMAGE_COUPERET);
    
    selection_active = false;
    
    couperet_x = 43;
    couperet_y = couperet_y_debut;
    couperet_angle = couperet_angle_debut;
    amplitude_choc_couperet = AMPLITUDE_CHOC_COUPERET;
    
    temps_menu = 0;
}


void mettre_a_jour_menu()
{
    if(!touches[ENTER])
    {
        selection_active = true;   
    }
    
    if(touche_relachee)
	{
    	menu.k = false;
	}
    
    temps_menu++;
    
	menu.update();
}


void dessiner_menu()
{
    ecran.background(#EFEFEF);
    
    imageMenu.afficher(0, 0);
    menu.bjouer.afficher();
    menu.bcredits.afficher();
    menu.bquitter.afficher();
    
    dessiner_couperet();
}


void terminer_menu()
{
	menu_init = false;
}


void dessiner_couperet()
{
    ecran.pushMatrix();
    
	if(couperet_y < couperet_y_fin)
	{
    	couperet_y = couperet_y_debut + temps_menu * (couperet_y_fin - couperet_y_debut) / (IMAGES_PAR_SECONDE * DUREE_ANIMATION_COUPERET);
		couperet_angle = couperet_angle_debut + temps_menu * (couperet_angle_fin - couperet_angle_debut) / (IMAGES_PAR_SECONDE * DUREE_ANIMATION_COUPERET);
	}
	else
	{
    	ecran.translate(random(-amplitude_choc_couperet, amplitude_choc_couperet), random(-amplitude_choc_couperet, amplitude_choc_couperet));
    	amplitude_choc_couperet /= REDUCTION_CHOC_COUPERET;
    	
    	if(amplitude_choc_couperet < 0.1)
    	{
        	amplitude_choc_couperet = 0;
    	}
	}
	
	ecran.translate(couperet_x, couperet_y);
	ecran.rotate(couperet_angle);
	couperet.afficher(-40, -20);
	
	ecran.popMatrix();
}


class MenuPrincipal { 
    boolean k = false;
    
    Bouton bjouer = new Bouton(224,91,"Jouer",true, IMAGE_BOUTON_JOUER);
    Bouton bcredits = new Bouton(224,119,"Crédits",false, IMAGE_BOUTON_CREDITS);
    Bouton bquitter = new Bouton(224,147,"Quitter",false, IMAGE_BOUTON_QUITTER);

    void update() {
        
        if (keyPressed == true && selection_active) {
            if (bjouer.select == true && k == false) {                    // Bouton JOUER sélectionné
                if (touches[UP] == true) {
                    bjouer.select = false;
                    bquitter.select = true;
                } else if (touches[DOWN] == true) {
                    bjouer.select = false;
                    bcredits.select = true;
                } else if (touches[ENTER] == true) {
                    println("Changer d'écran -> JOUER");
                }
            } else if (bcredits.select == true && k == false) {            // Bouton CREDITS sélectionné
                if (touches[UP] == true) {
                    bcredits.select = false;
                    bjouer.select = true;
                } else if (touches[DOWN] == true) {
                    bcredits.select = false;
                    bquitter.select = true;
                } else if (touches[ENTER] == true) {
                    scene = SCENES[CREDITS];
                    terminer_menu();
                }
            } else if (bquitter.select == true && k == false) {            // Bouton QUITTER sélectionné
                if (touches[UP] == true) {
                    bquitter.select = false;
                    bcredits.select = true;
                } else if (touches[DOWN] == true) {
                    bquitter.select = false;
                    bjouer.select = true;
                } else if (touches[ENTER] == true) {
                    exit();
                }
            }
            k = true;
        }
    }
}


class Bouton {
    float posx, posy;
    int hauteur;
    String type;
    boolean select;
    Image imageBouton;

    Bouton(int posx,int posy, String type, boolean select,String imageBouton) {
      this.posx = posx;
      this.posy = posy;
      this.type = type;
      this.select = select;
      this.imageBouton = new Image(imageBouton);
      hauteur = this.imageBouton.hauteur;
    }
    
    void afficher() {
        if (select == true) {
            imageCurseur.afficher(posx + 3, posy);        //Dessiner curseur
            imageBouton.afficher(posx + 20, posy);      //Dessiner bouton décalé
        } else {
            imageBouton.afficher(posx, posy);    //Dessiner bouton
        }
    }
}