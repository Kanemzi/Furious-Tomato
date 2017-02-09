/* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
 *   Furious Tomato - Par Benjamin Strabach, Valentin Galerne et Simon Rozec   *
 *                                                                             *
 *                   ~ Fichier de gestion de l'afficheur LCD ~                 *
 * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * */

/*
 TODO : LCD orange du meilleur score
*/

class AfficheurLCD
{
	Image image;
	Vecteur position;
	int type;


	AfficheurLCD(Vecteur position, int type)
    {
        this.position = position;
        this.type = type;
        image = new Image(IMAGE_CHIFFRES, 22, 0, ANIMATION_NON, false);
    }
    
    
    void mettre_a_jour()
    {
    	if(type == LCD_TYPE_SCORE)
    	{
        	
    	}
    }
    
    
    Image generer_image(int n)
    {
        int minutes = n / 60;
        int secondes = n % 60;
    	
    	PImage img_score = createImage(25, 7, ARGB);
    	
    	dessiner_chiffre_dans_image(img_score, image.index(chiffre_a_la_position(minutes, 1) + 10), 0);
    	dessiner_chiffre_dans_image(img_score, image.index(chiffre_a_la_position(minutes, 0)+ 10), 1);
    	dessiner_chiffre_dans_image(img_score, image.index((sin( (float)(temps_global * 2 * TWO_PI / IMAGES_PAR_SECONDE)) < 0) ? 20 : 21 ), 2);
    	dessiner_chiffre_dans_image(img_score, image.index(chiffre_a_la_position(secondes, 1)+ 10), 3);
    	dessiner_chiffre_dans_image(img_score, image.index(chiffre_a_la_position(secondes, 0)+ 10), 4);
    	
    	return new Image(img_score);
    }
    
    
    void dessiner_chiffre_dans_image(PImage affichage, PImage chiffre, int position)
    {
        for(int y = 0; y < 7 ; y++)
        {
            for(int x = 0; x < 5 ; x++)
            {
            	affichage.pixels[y * affichage.width + ( x + position * 5)] = chiffre.pixels[y * chiffre.width + x];
            }
        }
        
        affichage.updatePixels();
    }
    
    
    int chiffre_a_la_position(int n, int p)
    {
        return ( (int) ( n / pow(10, p) - (int) (n / pow(10, p + 1 ) ) * 10) );
    }
}