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
  
  cuisinier = new Cuisinier();
  
  joueur = new Joueur(new Vecteur(64, 64));
  saliere = new Saliere();
  
  entites.clear();
  entites.add(joueur);
  
  lcd = new AfficheurLCD(new Vecteur(3, 4), 0);
}


void mettre_a_jour_jeu()
{
  if (temps_global % IMAGES_PAR_SECONDE == 0)
  {
  	temps_partie ++;
  }
	
	boolean collision_sel = false;

  for (int i = 0; i < entites.size(); i++)
  {
    Entite e = entites.get(i);
    e.mettre_a_jour();
    
    
    if(e instanceof Sel && !collision_sel)
    {
        if(((Sel) e).collision(joueur)) collision_sel = true;
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
  
  if(!collision_sel)
  {
  	joueur.ralenti = false;   
  }

  //CODE TEMPORAIRE : 
  
  saliere.mettre_a_jour();
  cuisinier.mettre_a_jour();
}


void dessiner_jeu()
{
  gui.afficher(0, 0);
  planche.afficher(0, 50);
  

  imge = lcd.generer_image( (int) temps_partie);
  ecran.image(imge.actuelle(), 71, 10);
  
  for (int i = 0; i < entites.size(); i++)
  {
    Entite e = entites.get(i);
    e.afficher();
  }
  
  saliere.afficher();
  cuisinier.afficher();
}


void terminer_jeu()
{
   supprimer_tremblement();
  scene = SCENES[FIN];
  jeu_init = false;
}