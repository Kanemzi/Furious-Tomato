/* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
 *   Furious Tomato - Par Benjamin Strabach, Valentin Galerne et Simon Rozec   *
 *                                                                             *
 *                    ~ Gestion de l'écran en cours de partie ~                *
 * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * */

boolean jeu_init = false;

int temps_partie;

Image gui;
Image planche;
Image imge;

CompteARebours compte_a_rebours;

Cuisinier cuisinier;

AfficheurLCD lcd;

Joueur joueur; // une référence vers le joueur
Saliere saliere; // une référence vers la salière

void initialiser_jeu()
{
  retour_active = false;

  temps_partie = 0;
  gui = new Image(IMAGE_INTERFACE);
  planche = new Image(IMAGE_PLANCHE);
  
  compte_a_rebours = new CompteARebours();
  
  cuisinier = new Cuisinier();
  
  joueur = new Joueur(new Vecteur(64, 64));
  saliere = new Saliere();
  
  entites.clear();
  entites.add(joueur);
  
  joueur.visible = false;
  
  lcd = new AfficheurLCD(new Vecteur(3, 4), 0);
}


void mettre_a_jour_jeu()
{
  compte_a_rebours.mettre_a_jour();
  
  if ( compte_a_rebours.fini == false )
  {
      return;
  }
    
  if (temps_global % IMAGES_PAR_SECONDE == 0)
  {
  	temps_partie ++;
  }
	
	joueur.ralenti = false;


  for (int i = 0; i < entites.size(); i++)
  {
    Entite e = entites.get(i);
    e.mettre_a_jour();
    
    
    if(e instanceof Sel)
    {
        ((Sel) e).collision(joueur);
    }
    else if(e instanceof Couteau)
    {
        ((Couteau) e).collision(joueur);
    }
    
    if (e.morte)
    {
      e.detruire();
    }
  }

  //CODE TEMPORAIRE : 
  
  saliere.mettre_a_jour();
  cuisinier.mettre_a_jour();
}


void dessiner_jeu()
{
  gui.afficher(0, 0, ecran);
  planche.afficher(0, 50, ecran);
  

  imge = lcd.generer_image( (int) temps_partie);
  ecran.image(imge.actuelle(), 71, 10);
  
  for (int i = 0; i < entites.size(); i++)
  {
    Entite e = entites.get(i);
    e.afficher((e instanceof Couteau) ? masque_couteaux : ecran);
  }
  
  saliere.afficher();
  cuisinier.afficher();
  
  compte_a_rebours.dessiner();
}


void terminer_jeu()
{
   supprimer_tremblement();
  scene = SCENES[FIN];
  jeu_init = false;
}



class CompteARebours
{
    final float taille_texte_base = 64;
    
    boolean fini = false;
    boolean cacher = false;
    float opacite_compte_a_rebours = 255;
    float vitesse_degrade_compte_a_rebours = 255 / IMAGES_PAR_SECONDE;
    int a = 3;
    String texte;
    float taille_texte = 64;
    
    // Animation tomate
    final float DUREE_ANIMATION = (int) (IMAGES_PAR_SECONDE * (6.0/6.0));
    final float X_TOMATE_DEBUT = LARGEUR_PLANCHE + 24; //tailletomate;
    final float X_TOMATE_FIN = LARGEUR_PLANCHE / 2;
    final float Y_TOMATE_DEBUT = HAUTEUR_PLANCHE / 3;
    final float Y_TOMATE_FIN = HAUTEUR_ECRAN - 24 * 2;
    
    float temps_animation = 0;
    float x_tomate = X_TOMATE_DEBUT;
    float y_tomate = Y_TOMATE_DEBUT;
    
   	Image tomate_saut;
   	
   	CompteARebours()
   	{
    	tomate_saut = new Image(IMAGE_TOMATE_SAUT, 3, 0, ANIMATION_TOMATE_SAUT, false);
    	tomate_saut.origine(tomate_saut.largeur / 2, tomate_saut.hauteur / 2);
   	}
    
    void mettre_a_jour()
    {
        
        if (cacher) 
        {
            return;
        }
        
        opacite_compte_a_rebours -= vitesse_degrade_compte_a_rebours;
        
        if(texte != "Courez !!!")
        	taille_texte *= 0.99;
        else
        	taille_texte *= 0.995;
        
        
        
        if(a == 1 && opacite_compte_a_rebours <= 250 * (DUREE_ANIMATION / IMAGES_PAR_SECONDE) )
        {
            temps_animation++;
        	tomate_saut.mettre_a_jour();
        
        	println(temps_animation);
            
            float pourcentage_anim = temps_animation / DUREE_ANIMATION;
            
            if(temps_animation <= DUREE_ANIMATION * 0.5)
            {
            	tomate_saut.angle(tomate_saut.angle - TWO_PI / (DUREE_ANIMATION * 0.5));   
            }
            
            if(temps_animation == (int) (DUREE_ANIMATION * 0.5))
            {
                tomate_saut.index_image++;
			}

            x_tomate = X_TOMATE_DEBUT - pourcentage_anim * (X_TOMATE_DEBUT - X_TOMATE_FIN);
        	y_tomate = Y_TOMATE_DEBUT - fonction_saut(pourcentage_anim) * (Y_TOMATE_DEBUT - Y_TOMATE_FIN);
    	}
        
        if ( opacite_compte_a_rebours < 0 )
        {
            a--;
            
            opacite_compte_a_rebours = 255;
            taille_texte = taille_texte_base + a * 10;
            
            
            if ( a == 0 ) // fin du countdown 
            {
                fini = true;
                joueur.visible = true;
                joueur.position = new Vecteur(X_TOMATE_FIN, Y_TOMATE_FIN);
            	joueur.angle = HALF_PI;
            	trembler(40, .4, true);
            
				for(int i = 0; i < 30; i++)
        		{
            		Vecteur vitesse = new Vecteur(0, 0);
            		vitesse.modifierAL(random(0, TWO_PI), 1);
               
               		float acceleration = random(0.9, 0.95);
    
            		entites.add(0, new Particule(new Vecteur(x_tomate + tomate_saut.largeur / 2, y_tomate + tomate_saut.hauteur),
                                      vitesse,
                                      new Vecteur(acceleration, acceleration),
                                      #C1ACA0,
                                      random(1, 1.5), 
                                      (int) random(3, 4)
            		));
        		}
        	}
        
        	if(a == -1) cacher = true;
        }      
        
    }
    
    void dessiner()
    {   
        
        if(cacher)
        {
            return;
        }
        
        ecran.textSize(taille_texte);
        ecran.fill(255, opacite_compte_a_rebours);
        
        if(a > 0)
        {
        	texte = "" + a;
		}
		else
		{
    		ecran.textSize(taille_texte - 16);
    		texte = "Fuyez !!!";
    	}
		
		if(!fini)
		{
    		float pourcentage_anim = temps_animation / DUREE_ANIMATION;
    		masque_couteaux.fill(color(0, 0, 0, 30));
            masque_couteaux.noStroke();
            masque_couteaux.ellipse(x_tomate + tomate_saut.largeur / 2, Y_TOMATE_FIN - HAUTEUR_BANDEAU + tomate_saut.hauteur, (tomate_saut.largeur - 7) * pourcentage_anim, (tomate_saut.hauteur / 2 - 5) * pourcentage_anim); // dessin de l'ombre
        
    		tomate_saut.afficher(x_tomate + tomate_saut.origine_x , y_tomate + tomate_saut.origine_y, masque_couteaux);
		}


		ecran.textAlign(CENTER, CENTER);
		ecran.text(texte, LARGEUR_PLANCHE / 2 , (HAUTEUR_ECRAN - HAUTEUR_PLANCHE) + HAUTEUR_PLANCHE / 2 - 14);
		
	}

	float fonction_saut(float x)
	{
    	return pow(x, 3)+(1-sqrt(x))/2;
	}
}