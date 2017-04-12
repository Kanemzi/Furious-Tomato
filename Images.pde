/* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
 *   Furious Tomato - Par Benjamin Strabach, Valentin Galerne et Simon Rozec   *
 *                                                                             *
 *                       ~ Fichier de gestion des images ~                     *
 * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *  */

/*
    Cette classe correspond à une image destinée à être affichée dans le jeu. Cette image peut être animée
 */
class Image
{
    PImage[] images; // sous images
    int[] animation; // enchaînement des sous images (index)

    boolean animee; // défilement des sous images activé
    boolean boucler_animation;
    boolean miroir_x = false;
    boolean miroir_y = false;

    int index_image; // l'index de la sous image actuelle

    float vitesse_animation; // pourcentage de vitesse de changement des images (1 = 1 frame par tick)
    float opacite = 255; // opacité de l'image
    
    // point d'origine de l'image
    float origine_x = 0;
    float origine_y = 0;
    float angle = 0; // rotation de l'image

    // taille de l'image et de l'animation
    int largeur;
    int hauteur;
    int longueur_animation;

    boolean animation_finie; // si l'animation ne boucle pas et qu'elle est finie, = true


    /*
    	Crée une image animée à partir d'une seule image contenant toutes les étapes de l'animation placées les unes à la suite des autres
     */
    Image(String fichier, int nb_images, float vitesse_animation, int[] animation, boolean boucler_animation)
    {
        PImage image = loadImage("images/" + fichier); // chargement de l'image globale

        images = new PImage[nb_images]; // création d'un tableau de sous images

        // définition de la taille des sous images
        int case_h = image.height;
        int case_l = image.width / nb_images;

        for (int i = 0; i < nb_images; i++) // on boucle autant de fois qu'il doit y avoir de sous images
        {
            PImage sous_image = createImage(case_l, case_h, ARGB); // création d'une sous image vide

            for (int y = 0; y < case_h; y++)
            {
                for (int x = 0; x < case_l; x++)
                {
                    sous_image.pixels[y * case_l + x] = image.pixels[y * image.width + i * case_l + x];
                }
            }

            sous_image.updatePixels();

            images[i] = sous_image;
        }

        this.animee = (nb_images > 1) && vitesse_animation > 0;
        this.animation = animation;
        this.vitesse_animation = vitesse_animation;
        this.boucler_animation = boucler_animation;

        index_image = 0;
        longueur_animation = animation.length;
        largeur = images[0].width;
        hauteur = images[0].height;
    }


    /* 
     	Crée une image fixe
     */
    Image(String fichier)
    {
        PImage image = loadImage("images/" + fichier); // chargement de l'image

        images = new PImage[1];
        images[0] = image;

        this.animee = false;
        this.animation = ANIMATION_NON;
        this.vitesse_animation = 0;

        index_image = 0;
        longueur_animation = animation.length;
        largeur = images[0].width;
        hauteur = images[0].height;
    }


    /* 
     	Crée une image fixe à partir d'une PImage
     */
    Image(PImage img)
    {
        images = new PImage[1];
        images[0] = img;

        this.animee = false;
        this.animation = ANIMATION_NON;
        this.vitesse_animation = 0;

        index_image = 0;
        longueur_animation = animation.length;
        largeur = images[0].width;
        hauteur = images[0].height;
    }


    /*
    	Fait avancer l'animation de l'image. L'animation recommence une fois finie
     */
    void mettre_a_jour()
    {
        if (animee && vitesse_animation <= 1 && temps_global % round( 1 / vitesse_animation ) == 0 )
        {
            index_image ++;

            if (index_image == longueur_animation)
            {
                if (boucler_animation) 
                {
                    index_image = 0;
                }
                else
                {
                    index_image = longueur_animation - 1;
                    animation_finie = true;
                }
            }
        }
    }


    /*
		Affiche l'image aux coordonnées x et y indiquées
    */
    void afficher(float x, float y)
    {   
        
        ecran.pushMatrix();

        ecran.translate(x, y);
        ecran.rotate(angle);
		
		if(miroir_x || miroir_y)
		{
        	ecran.scale((miroir_x) ? -1 : 1, (miroir_y) ? -1 : 1);
        	ecran.translate(((miroir_x) ? -largeur : 0), ((miroir_y) ? -hauteur : 0));
		}		

        ecran.tint(255, opacite);
        ecran.image(actuelle(), ((miroir_x) ? 1 : -1) * origine_x, ((miroir_y) ? 1 : -1) * origine_y);

        ecran.popMatrix();    
    }


    /*
        Retourne l'image actuelle de l'animation
     */
    PImage actuelle()
    {
        return images[animation[index_image]];
    }


    /*
        Retourne une sous-image à un index précis
    */
    PImage index(int index)
    {	
        if (index >= images.length)
        {
            return images[0];
        }
        else
        {
            return images[index];
        }
    }


    /*
		Retourne true si l'animation ne boucle pas et qu'elle est finie
     	*/
    boolean animation_finie()
    {
        return (!boucler_animation) && (index_image == longueur_animation - 1);
    }


    /*
        Change l'animation attribuée à l'image
     */
    void changerAnimation(int[] animation, float vitesse_animation, boolean restart, boolean retour_debut, boolean boucler_animation)
    {
        if (!restart && animation == this.animation)
        {
            return;
        }

        this.animation = animation;
        this.boucler_animation = boucler_animation;
        this.vitesse_animation = vitesse_animation;
        this.longueur_animation = animation.length;

        if (retour_debut)
        {
            index_image = 0;
        }
    }


    /*
		Change la vitesse à laquelle se déroule l'animation
     	*/
    void changerVitesseAnimation(float vitesse_animation)
    {
        this.vitesse_animation = vitesse_animation;
        animation_finie = false;
    }


    /*
		Fait boucler ou non l'animation
     	*/
    void faireBouclerAnimation(boolean boucler_animation)
    {
        this.boucler_animation = boucler_animation;
    }


    /*
    	Modifie l'opacité de l'image
     */
    void opacite(float o)
    {
        opacite = o;
    }


    /*
    	Modifie l'angle de l'image
     */
    void angle(float a)
    {
        angle = a;
    }


    /*
		Modifie le point d'origine de l'image
     	*/
    void origine(float x, float y)
    {
        origine_x = x;
        origine_y = y;
    }
}