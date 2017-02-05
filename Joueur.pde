class Joueur extends Entite
{
    float angle;	  

	    float v = 2;
    float angle_target;

    Joueur(Vecteur pos)
    {
        super(pos, new Image(IMAGE_TOMATE, 20, 0.2, ANIMATION_TOMATE_PROFIL_FACE, true));
    }
   
    void mettre_a_jour()
    {
    	  super.mettre_a_jour();
        
        float axeX = 0;
        float axeY = 0;
        
        if(touches[LEFT]) axeX += 1;
        if(touches[RIGHT]) axeX += -1;
        
        if(touches[UP]) axeY += -1;
        if(touches[DOWN]) axeY += 1;
        
        if(axeX == 0 && axeY == 0) {
            v = 0;
        } else {
            v = 2; 
            angle = atan2(axeX, axeY);
       }
       
       image.miroir_x = angle > 0 && angle < PI;
       
       if(angle == 0) {
         image.changerAnimation(ANIMATION_TOMATE_FACE, 0.2, false, false);
       } else if(angle == -PI/2 || angle == -PI/4 || angle == PI/2 || angle == PI/4) {
         image.changerAnimation(ANIMATION_TOMATE_PROFIL_FACE, 0.2, false, false);
       } else if(angle == PI) {
           image.changerAnimation(ANIMATION_TOMATE_DOS, 0.2, false, false);
       }  else if(angle == -3*PI/4 || angle == 3*PI/4) {
         image.changerAnimation(ANIMATION_TOMATE_PROFIL_DOS, 0.2, false, false);
       } 
      
        vitesse.modifierAL(angle + PI/2 , v);
        
        if(vitesse.longueur() == 0) {
        	image.changerVitesseAnimation(0);
        	image.index_image = 0;
        } else {
        	image.changerVitesseAnimation(0.2);
        }
        
        if(position.x < 0) position.x = 0;
    	if(position.x > 218 - image.largeur / 2) position.x = 218 - image.largeur / 2;
    	if(position.y > HAUTEUR_ECRAN - image.hauteur - 7) position.y = HAUTEUR_ECRAN - image.hauteur - 7;
    	if(position.y < 40) position.y = 40;
	}
    
    void afficher()
    {
        super.afficher();   
    }
}