/* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
 *   Furious Tomato - Par Benjamin Strabach, Valentin Galerne et Simon Rozec   *
 *                                                                             *
 *                     ~ Gestion de l'écran du menu du jeu ~                   *
 * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * */

/*
	Idées:
		- Bouts de tomate qui sont éjectés lors du choc
		- Couverts aussi éjectés lors du choc
*/

// Boutons du menu
boolean menu_init = false;
boolean selection_active;

MenuPrincipal menu;
Image imageCurseur;


// Image de fond du menu
Image image_menu;


int temps_menu;

// Animation de la tomate
Image tomate;

boolean tomate_morte = false;

float tomate_x;

final float TOMATE_X_DEBUT = -28,
			TOMATE_X_FIN = 80;


// Animation du couperet
Image couperet;

final float COUPERET_Y_DEBUT = -200,
			COUPERET_Y_FIN = 24;

final float couperet_angle_debut = - PI / 2,
            couperet_angle_fin = 0;

float couperet_x, couperet_y;
float couperet_angle;
float amplitude_choc_couperet;


// Animation de l'explosion de la tomate
Image explosion_tomate;


void initialiser_menu()
{
    menu =  new MenuPrincipal();
    selection_active = false;
    
    imageCurseur = new Image(IMAGE_CURSEUR);
    image_menu = new Image(IMAGE_MENU);
    
    tomate = new Image(IMAGE_TOMATE, 20, 0.2, ANIMATION_TOMATE_PROFIL_FACE, true);
    couperet = new Image(IMAGE_COUPERET);
    explosion_tomate = new Image(IMAGE_EXPLOSION_TOMATE, 4, 1, ANIMATION_EXPLOSION_TOMATE, false);
    
    tomate_morte = false;
    tomate_x = TOMATE_X_DEBUT;
    
    couperet_x = 42;
    couperet_y = COUPERET_Y_DEBUT;
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
    if(amplitude_choc_couperet < AMPLITUDE_CHOC_COUPERET) ecran.translate(random(-amplitude_choc_couperet, amplitude_choc_couperet), random(-amplitude_choc_couperet, amplitude_choc_couperet));
    
    image_menu.afficher(0, 0);
    
    menu.bjouer.afficher();
    menu.bcredits.afficher();
    menu.bquitter.afficher();
    
    dessiner_tomate();
    dessiner_couperet();
}


void dessiner_couperet()
{
    ecran.pushMatrix();
    
    if(couperet_y < COUPERET_Y_FIN)
    {
        couperet_y = COUPERET_Y_DEBUT + temps_menu * (COUPERET_Y_FIN - COUPERET_Y_DEBUT) / (IMAGES_PAR_SECONDE * DUREE_ANIMATION_COUPERET);
        couperet_angle = couperet_angle_debut + temps_menu * (couperet_angle_fin - couperet_angle_debut) / (IMAGES_PAR_SECONDE * DUREE_ANIMATION_COUPERET);
    }
    else
    {
        tomate_morte = true;
        
        amplitude_choc_couperet /= REDUCTION_CHOC_COUPERET;
        
        if(amplitude_choc_couperet < 0.1)
        {
            amplitude_choc_couperet = 0;
        }
    
        explosion_tomate.afficher(0, 47);
        explosion_tomate.mettre_a_jour();
    }
    
    ecran.translate(couperet_x, couperet_y);
    ecran.rotate(couperet_angle);
    couperet.afficher(-40, -20);
    
    ecran.popMatrix();
}


void dessiner_tomate()
{
    if(!tomate_morte)
    {
        tomate_x = TOMATE_X_DEBUT + temps_menu * (TOMATE_X_FIN - TOMATE_X_DEBUT) / (IMAGES_PAR_SECONDE  * DUREE_ANIMATION_TOMATE);
        
        tomate.afficher(tomate_x, 74);
        tomate.mettre_a_jour();
    }
}


void terminer_menu()
{
	menu_init = false;
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
                    scene = SCENES[JEU];
                    terminer_menu();
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