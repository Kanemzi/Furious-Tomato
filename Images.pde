/* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
 *   Furious Tomato - Par Benjamin Strabach, Valentin Galerne et Simon Rozec   *
 *                                                                             *
 *                       ~ Fichier de gestion des images ~                     *
 * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * */

/*
    Cette classe correspond à une image destinée à être affichée dans le jeu. Cette image peut être animée
 */
class Image
{
  PImage[] images;
  int[] animation;

  boolean animee;
  boolean boucler_animation;
  boolean miroir_x = false;
  boolean miroir_y = false;

  int index_image;

  float vitesse_animation;
  float opacite = 255;
  float origine_x = 0;
  float origine_y = 0;
  float angle = 0;    

  int largeur;
  int hauteur;
  int longueur_animation;

  boolean animation_finie;


  /*
    	Crée une image animée à partir d'une seule image contenant toutes les étapes de l'animation placées les unes à la suite des autres
   */
  Image(String fichier, int nb_images, float vitesse_animation, int[] animation, boolean boucler_animation)
  {
    PImage image = loadImage("images/" + fichier);

    images = new PImage[nb_images];

    int case_h = image.height;
    int case_l = image.width / nb_images;

    for (int i = 0; i < nb_images; i++)
    {
      PImage sous_image = createImage(case_l, case_h, ARGB);

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
    PImage image = loadImage("images/" + fichier);

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
        } else
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

    if (miroir_x)
    {
      ecran.scale(-1, 1);
      ecran.translate(- largeur, 0);
    }

    if (miroir_y)
    {
      ecran.scale(1, -1);
      ecran.translate(0, - hauteur);
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
    } else
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