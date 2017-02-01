class Joueur extends Entite
{
    float angle;	  

	    float v = 2;
    float angle_target;

    Joueur(Vecteur pos)
    {
        super(pos, new Image(IMAGE_TOMATE, 20, 0.2, ANIMATION_TOMATE_PROFIL));
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
       
       if(angle < PI/8 && angle > -PI/8) {
         image.changerAnimation(ANIMATION_TOMATE_FACE, 0.2, false);
       } else {
         image.changerAnimation(ANIMATION_TOMATE_PROFIL, 0.2, false);
       }
      
        vitesse.modifierAL(angle + PI/2 , v);
    }
}