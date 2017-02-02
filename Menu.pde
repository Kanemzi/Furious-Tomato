/* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
 *   Furious Tomato - Par Benjamin Strabach, Valentin Galerne et Simon Rozec   *
 *                                                                             *
 *                     ~ Gestion de l'écran du menu du jeu ~                   *
 * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * */

boolean menu_init = false;
MenuPrincipal menu;


void initialiser_menu()
{
    menu =  new MenuPrincipal();
}


void mettre_a_jour_menu()
{
	menu.update();
}


void dessiner_menu()
{
    ecran.background(0);
	menu.bjouer.afficher();
    menu.bcredits.afficher();
    menu.bquitter.afficher();
}


void terminer_menu()
{
	menu_init = false;
}


class MenuPrincipal { 
    boolean k = false;
    
    Bouton bjouer = new Bouton(10,15,"Jouer",true, IMAGE_BOUTON_JOUER);
    Bouton bcredits = new Bouton(10,70,"Crédits",false, IMAGE_BOUTON_CREDITS);
    Bouton bquitter = new Bouton(10,125,"Quitter",false, IMAGE_BOUTON_QUITTER);

    void update() {
        
        if (keyPressed == true) {
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
    Image image;

    Bouton(int posx,int posy, String type, boolean select,String image) {
      this.posx = posx;
      this.posy = posy;
      this.type = type;
      this.select = select;
      this.image = new Image(image);
      hauteur = this.image.hauteur;
    }
    
    void afficher() {
        if (select == true) {
                    //Dessiner curseur
            image.afficher(posx + 20, posy);      //Dessiner bouton décalé
        } else {
            image.afficher(posx, posy);    //Dessiner bouton
        }
    }
}