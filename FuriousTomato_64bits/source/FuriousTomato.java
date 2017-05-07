import processing.core.*; 
import processing.data.*; 
import processing.event.*; 
import processing.opengl.*; 

import ddf.minim.*; 

import java.util.HashMap; 
import java.util.ArrayList; 
import java.io.File; 
import java.io.BufferedReader; 
import java.io.PrintWriter; 
import java.io.InputStream; 
import java.io.OutputStream; 
import java.io.IOException; 

public class FuriousTomato extends PApplet {

/* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
 *   Furious Tomato - Par Benjamin Strabach, Valentin Galerne et Simon Rozec   *
 *                                                                             *
 *                             ~ Fichier principal ~                           *
 * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * */

String scene;
int temps_global;

Transition transition;
Tremblement tremblement;

public void settings()
{
  switch(ECHELLE)
  {
  case 1:
    size(320, 180, FX2D);
    break;

  case 2:
    size(640, 360);
    break;

  case 3:
    size(960, 540);
    break;

  case 4:
    size(1280, 720);
    break;
    
  case 5:
  	size(1600,900);
  	break;
  
  case 6:
  	fullScreen();
  	break;
  }

  noSmooth();
}


public void setup()
{
  frameRate(IMAGES_PAR_SECONDE);

  temps_global = 0;
  scene = SCENES[INTRO];

  initialiser_son();
  initialiser_ecran();
  initialiser_police();

  transition = new Transition();
  tremblement = initialiser_tremblement();
}


public void draw()
{

  //surface.setLocation((int)(128 + sin((float)temps_global /( (float)IMAGES_PAR_SECONDE / 18))* 128) , (int) (128 + cos((float)temps_global / (2*(float)IMAGES_PAR_SECONDE / 20))* 128) ); // faire bouger l'\u00e9cran lel !!! x) x) xD ptdr

  temps_global ++;

  surface.setTitle("Furious Tomato    (fps: "+(int) frameRate + ")");

  ecran.beginDraw();

  tremblement.mettre_a_jour();

  if (scene == SCENES[INTRO])
  {
    if (!intro_init)
    {
      intro_init = true;
      initialiser_intro();
    }

    mettre_a_jour_intro();
    dessiner_intro();
  } else if (scene == SCENES[MENU])
  {
    if (!menu_init)
    {
      menu_init = true;
      initialiser_menu();
    }

    mettre_a_jour_menu();
    dessiner_menu();
  } else if (scene == SCENES[CREDITS])
  {
    if (!credits_init)
    {
      credits_init = true;
      initialiser_credits();
    }

    mettre_a_jour_credits();
    dessiner_credits();
  } else if (scene == SCENES[JEU])
  {
    if (!jeu_init)
    {
      jeu_init = true;
      initialiser_jeu();
    }

    mettre_a_jour_jeu();
    dessiner_jeu();
  } else if (scene == SCENES[FIN])
  {
    if (!fin_init)
    {
      fin_init = true;
      initialiser_fin();
    }

    mettre_a_jour_fin();
    dessiner_fin();
  }

  transition.mettre_a_jour();
  transition.afficher();

  ecran.endDraw();

  image(ecran, 0, 0, width, height);
  mettre_a_jour_entrees();
  
  // capture d'\u00e9cran
  if(touches[CONTROL]) saveFrame();
}
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
    Image generation;
    PImage img_score;
    int type;

    boolean double_points;


    AfficheurLCD(int type)
    {
        this.type = type;
        image = new Image(IMAGE_CHIFFRES, 22, 0, ANIMATION_NON, false);
        img_score = createImage(25, 7, ARGB);
        generation = new Image(img_score);

        double_points = false;
    }


    public Image generer_image(int n)
    {

        int minutes = n / 60;
        int secondes = n % 60;

        if (type == LCD_TYPE_SCORE)
        {
            if (temps_global % (IMAGES_PAR_SECONDE / 2) != 0)
            {
                return generation;
            }

            double_points = !double_points;

            dessiner_chiffre_dans_image(img_score, image.index(chiffre_a_la_position(minutes, 1) + 10), 0);
            dessiner_chiffre_dans_image(img_score, image.index(chiffre_a_la_position(minutes, 0)+ 10), 1);
            dessiner_chiffre_dans_image(img_score, image.index((double_points) ? 20 : 21), 2);
            dessiner_chiffre_dans_image(img_score, image.index(chiffre_a_la_position(secondes, 1)+ 10), 3);
            dessiner_chiffre_dans_image(img_score, image.index(chiffre_a_la_position(secondes, 0)+ 10), 4);
        } else
        {
            dessiner_chiffre_dans_image(img_score, image.index(chiffre_a_la_position(minutes, 1)), 0);
            dessiner_chiffre_dans_image(img_score, image.index(chiffre_a_la_position(minutes, 0)), 1);

            dessiner_chiffre_dans_image(img_score, image.index(chiffre_a_la_position(secondes, 1)), 3);
            dessiner_chiffre_dans_image(img_score, image.index(chiffre_a_la_position(secondes, 0)), 4);
        }

        return generation;
    }


    public void dessiner_chiffre_dans_image(PImage affichage, PImage chiffre, int position)
    {
        for (int y = 0; y < 7; y++)
        {
            for (int x = 0; x < 5; x++)
            {
                affichage.pixels[y * affichage.width + ( x + position * 5)] = chiffre.pixels[y * chiffre.width + x];
            }
        }

        affichage.updatePixels();
    }


    public int chiffre_a_la_position(int n, int p)
    {
        return ( (int) ( n / pow(10, p) - (int) (n / pow(10, p + 1 ) ) * 10) );
    }
}
/* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
 *   Furious Tomato - Par Benjamin Strabach, Valentin Galerne et Simon Rozec   *
 *                                                                             *
 *                          ~ Fichier de configuration ~                       *
 * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *  */

/* Informations globales */
final String VERSION = "release v1.2";
final int LARGEUR_ECRAN = 320;
final int HAUTEUR_ECRAN = 180;
final int LARGEUR_PLANCHE = 230;
final int HAUTEUR_PLANCHE = 130;
final int HAUTEUR_BANDEAU = HAUTEUR_ECRAN - HAUTEUR_PLANCHE;
final int ECHELLE = 3; // taille des pixels
final float IMAGES_PAR_SECONDE = 60;


/* Images */
final String IMAGE_LOGO_INTRO = "logo_isn2017.png";

final String IMAGE_COUPERET = "couperet.png";
final String IMAGE_EXPLOSION_TOMATE = "explosion_tomate.png";
final String IMAGE_BOUTON_JOUER = "jouer.png";
final String IMAGE_BOUTON_CREDITS = "credits.png";
final String IMAGE_BOUTON_QUITTER = "quitter.png";
final String IMAGE_CURSEUR = "curseur.png";
final String IMAGE_MENU = "menu.png";

final String IMAGE_FOND_CREDITS = "credits_fond.png";
final String IMAGE_BOUTON_ENTRER = "bouton_entrer.png";

final String IMAGE_CUISINIER = "animation_cuisinier.png";
final String IMAGE_TOMATE = "animation_tomate.png";
final String IMAGE_TOMATE_MORT = "tomate_mort.png";
final String IMAGE_TOMATE_SAUT = "tomate_saut.png";
final String IMAGE_COUTEAU = "couteau.png";
final String IMAGE_SALIERE = "saliere.png";
final String IMAGE_PLANCHE = "planche.png";
final String IMAGE_INTERFACE = "interface.png";
final String IMAGE_SALIERE_MINI = "saliere_mini.png";
final String IMAGE_CHIFFRES = "chiffres.png";
final String IMAGE_TUTORIEL = "tutoriel.png";


/* Animation des images (encha\u00eenement des sous-images) */
final int[] ANIMATION_NON = {0};
final int[] ANIMATION_EXPLOSION_TOMATE = {0, 1, 2, 3};
final int[] ANIMATION_CUISINIER_NORMAL = {0, 1, 0, 2};
final int[] ANIMATION_CUISINIER_ENERVE = {3, 4};
final int[] ANIMATION_TOMATE_PROFIL_FACE = {0, 1, 2, 1, 0, 3, 4, 3};
final int[] ANIMATION_TOMATE_PROFIL_DOS = {5, 6, 7, 6, 5, 8, 9, 8};
final int[] ANIMATION_TOMATE_FACE = {10, 11, 12, 11, 10, 13, 14, 13};
final int[] ANIMATION_TOMATE_DOS = {15, 16, 17, 16, 15, 18, 19, 18};
final int[] ANIMATION_TOMATE_MORT = {0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11};
final int[] ANIMATION_TOMATE_SAUT = {0, 1, 2};


/* Menu */
final float DUREE_ANIMATION_TOMATE = 0.6f;
final float DUREE_ANIMATION_COUPERET = 0.6f;
final float AMPLITUDE_CHOC_COUPERET = 64;
final float REDUCTION_CHOC_COUPERET = 1.2f;


/* Autres */
final float DUREE_TRANSITION = 0.5f;

final String POLICE = "fonts/Gibberesque.ttf";
final float TAILLE_POLICE = 16;


/* Contr\u00f4les du jeu */
final int TOUCHE_HAUT = UP;
final int TOUCHE_BAS = DOWN;
final int TOUCHE_DROITE = RIGHT;
final int TOUCHE_GAUCHE = LEFT;
final int TOUCHE_IMPULSION = 32;
final int TOUCHE_VALIDER = ENTER;
final int TOUCHE_RETOUR = RETURN;


/* DEBUG */
final boolean AFFICHER_COLLISIONS = false;
final boolean COLLISIONS_COUTEAUX = true;
final boolean AFFICHER_MOUVEMENT = false;


/* CONSTANTES */
final int INTRO = 0;
final int MENU = 1;
final int CREDITS = 2;
final int JEU = 3;
final int FIN = 4;
final int QUITTER = 5;
final String[] SCENES = {"intro", "menu", "credits", "jeu", "fin", "quitter"};

final int LCD_TYPE_SCORE = 0;
final int LCD_TYPE_MEILLEUR_SCORE = 1;
/* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
 *   Furious Tomato - Par Benjamin Strabach, Valentin Galerne et Simon Rozec   *
 *                                                                             *
 *                      ~ Fichier de gestion des couteaux ~                    *
 * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * */

ArrayList<Couteau> couteaux = new ArrayList<Couteau>(); // liste des couteaux affich\u00e9s \u00e0 l'\u00e9cran

class Couteau extends Entite
{
    float vieCouteau;
	Vecteur position_cible; // sauvegarde de la position cible (pour le clonage)	

    Couteau(Vecteur position, Vecteur positionCible)
    {
        super(position, new Image(IMAGE_COUTEAU));
        parametrer_collision(image.hauteur * 1.5f, new Vecteur(0, 0), AFFICHER_COLLISIONS);

        image.origine(image.largeur/2, image.hauteur/2);
        image.angle(random(0, TWO_PI));
        float a = angle_entre(position.x, position.y, positionCible.x, positionCible.y);
        vitesse.modifierAL(a, DIFF_vitesse_couteaux);

        vieCouteau = 10 * IMAGES_PAR_SECONDE;
        
        position_cible = positionCible;
        
        if(DIFF_couteaux_derives && (int) random(2) == 0)
        {
			Vecteur ac = vitesse.copie().normalise();

			ac.modifierAL(ac.direction() +random(- PI / 2, PI / 2), ac.longueur() * 0.08f);
			acceleration = ac;
        }
    }


    public void mettre_a_jour()
    {
        super.mettre_a_jour();
        image.angle(image.angle + PI/10);
        decalage_collision.x = -cos(image.angle) * (image.largeur / 4);
        decalage_collision.y = -sin(image.angle) * (image.largeur / 4);

        vieCouteau --;
        
        boolean sortie_ecran = (position.x < -64) || (position.x > LARGEUR_PLANCHE + 64) || (position.y < HAUTEUR_BANDEAU - 64 ) || (position.y > HAUTEUR_ECRAN + 64);
        
        if ( vieCouteau <= 0 || sortie_ecran)
        {
            morte = true;
        }
    }
    
    
    public void detruire()
    {
        couteaux.remove(this);
    }


    public void collision(Joueur j)
    {
        if (!super.collision(j)) 
            return;

        if (!j.impulsion && !j.perdu) 
        {
            j.perdu();

            for (int i = 0; i < 50; i++)
            {
                boolean pepin = (int) random(7) == 0;

                Vecteur v;
                if (random(10) < 4)
                {
                    v = new Vecteur(random(-6, 6), random(-3, 3));
                }
                else
                {
                    v = new Vecteur(0, 0);
                    v.modifierAL(vitesse.direction() + random(-PI/20, PI/20), vitesse.longueur() + random(4, 20));
                }

                entites.add(0, new Particule(new Vecteur(position.x + decalage_collision.x, position.y + decalage_collision.y), 
                    v, 
                    new Vecteur(random(0.2f, 0.8f), random(0.2f, 0.8f)), 
                    (pepin) ? 0xffE28F41 : 0xffC64617, 
                    random(1, 2), (pepin) ? 2 : (int) random(2, 4)
                ));
            }
        }
    }
}


class GenerateurCouteau 
{
    float intervalleCouteau;
    float temps;
    
    GenerateurCouteau()
    {
        temps = 6;
    }


    public void mettre_a_jour()
    {
        temps--;
        
        if (temps <= 0)
        {
            couteaux.add(new Couteau(genererPosition(), genererCible()));
            temps = DIFF_delais_couteaux * IMAGES_PAR_SECONDE;
        }
    }


    public Vecteur genererPosition()
    {
        Vecteur v = new Vecteur(0, 0);
        if ( random(100) > 50 )
        {
            v.x = random(LARGEUR_PLANCHE);
            
            if ( random(100) > 50 )
            {
                v.y = HAUTEUR_BANDEAU - 16;
            }
            else
            {
                v.y = HAUTEUR_ECRAN + 16;
            }
        }
        else
        {
            v.y = random(HAUTEUR_BANDEAU, HAUTEUR_ECRAN);
            
            if ( random(100) > 50 )
            {
                v.x = - 16;
            }
            else
            {
                v.x = LARGEUR_PLANCHE + 16;
            }
        }
        return v;
    }


    public Vecteur genererCible()
    {
        Vecteur v = new Vecteur(0, 0);
        if ( (int) random(3) == 0)
        {
            v.x = joueur.position.x + joueur.decalage_collision.x + random(-32, 32);
            v.y = joueur.position.y + joueur.decalage_collision.y + random(-32, 32);
        }
        else
        {
            if(DIFF_couteaux_derives)
            {
                float reduction = 0.1f;
                float tx = LARGEUR_PLANCHE * reduction;
                float decx = (LARGEUR_PLANCHE * (1 - reduction)) * 0.5f;
                
                float ty = HAUTEUR_PLANCHE * reduction;
                float decy = (HAUTEUR_PLANCHE * (1 - reduction)) * 0.5f;
                
            	v.x = random(decx, decx + tx);
            	v.y = random(HAUTEUR_BANDEAU + decy, HAUTEUR_BANDEAU + decy + ty);
        	}
        	else
        	{
            	v.x = random(LARGEUR_PLANCHE);
                v.y = random(HAUTEUR_BANDEAU, HAUTEUR_ECRAN);            
        	}
    	}

        return v;
    }
}
/* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
 *   Furious Tomato - Par Benjamin Strabach, Valentin Galerne et Simon Rozec   *
 *                                                                             *
 *                       ~ Gestion de l'\u00e9cran des cr\u00e9dits ~                    *
 * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * */

boolean credits_init = false;

boolean retour_active;
boolean credits_entrer_presse;

Image fond_credits;
Image bouton_entrer;


public void initialiser_credits()
{
    fond_credits = new Image(IMAGE_FOND_CREDITS);
    bouton_entrer = new Image(IMAGE_BOUTON_ENTRER);
    retour_active = false;
    credits_entrer_presse = false;

    demande_menu = false;
}


public void mettre_a_jour_credits()
{
    if (!touches[ENTER])
    {
        retour_active = true; // permet le retour au menu si "entrer" a \u00e9t\u00e9 rel\u00e2ch\u00e9 depuis l'entr\u00e9e dans cet \u00e9cran

        if (credits_entrer_presse && !demande_menu) // si on rel\u00e2che apr\u00e8s avoir s\u00e9lectionn\u00e9 le bouton de retour
        {
            demande_menu = true; // on lance la transition pour retourner au menu
            son_bouton_retour.trigger();
    		transition.lancer();
        }
    }

    if (touches[ENTER] && retour_active) // on enclenche le retour au menu
    {
        credits_entrer_presse = true;
    }

    if (transition.demi_transition_passee() && demande_menu) // si la transition arrive \u00e0 la moiti\u00e9 et qu'on demande bien un retour au menu
    {
        demande_menu = false;
        terminer_credits(); // on quitte l'\u00e9cran cr\u00e9dits
    }
}


public void dessiner_credits()
{
    fond_credits.afficher(0, 0);

    ecran.fill(0xfff0f0f0);
    ecran.textAlign(CENTER);
    ecran.text("Par \nBenjamin STRABACH \n Simon ROZEC \n Valentin GALERNE", LARGEUR_ECRAN / 2, 64);

    if (credits_entrer_presse)
    {
        bouton_entrer.afficher(10, 143);
    }
}


public void terminer_credits()
{
    scene = SCENES[MENU];
    credits_init = false;
}
/* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
 *   Furious Tomato - Par Benjamin Strabach, Valentin Galerne et Simon Rozec   *
 *                                                                             *
 *                      ~ Fichier de gestion du cuisinier ~                    *
 * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * */

class Cuisinier extends Entite
{
    final Pattern[][] PATTERNS = 
        {
        {
            new Pattern(PATTERN_3_COUTEAUX_DESCENTE), 
            new Pattern(PATTERN_3_COUTEAUX_MONTEE), 
            new Pattern(PATTERN_3_COUTEAUX_GAUCHE), 
            new Pattern(PATTERN_3_COUTEAUX_DROITE), 
            new Pattern(PATTERN_CROIX_4_COUTEAUX), 
            new Pattern(PATTERN_BORDS_8_COUTEAUX), 
            new Pattern(PATTERN_VAGUES_DIAGONALES_3_PHASES), 
            new Pattern(PATTERN_GRILLE_3_PHASES_3_COUTEAUX)
        }, 
        { // salty
            new Pattern(PATTERN_BORDS_8_COUTEAUX), 
            new Pattern(PATTERN_VAGUES_DIAGONALES_3_PHASES), 
            new Pattern(PATTERN_CROIX_4_COUTEAUX), 
            new Pattern(PATTERN_CROIX_4_COUTEAUX_CENTRE_LIBRE), 
            new Pattern(PATTERN_GRILLE_3_PHASES_3_COUTEAUX), 
            new Pattern(PATTERN_4_COUTEAUX_MONTEE), 
            new Pattern(PATTERN_4_COUTEAUX_DESCENTE), 
            new Pattern(PATTERN_BOOMERANG_DESCENTE_4_3)
        }, 
        { // nervous
            new Pattern(PATTERN_CROIX_4_COUTEAUX), 
            new Pattern(PATTERN_CROIX_4_COUTEAUX_CENTRE_LIBRE), 
            new Pattern(PATTERN_BORDS_8_COUTEAUX), 
            new Pattern(PATTERN_HELICE_4_COUTEAUX), 
            new Pattern(PATTERN_MIGRATEURS_GAUCHE_5_COUTEAUX), 
            new Pattern(PATTERN_MIGRATEURS_DROITE_5_COUTEAUX), 
            new Pattern(PATTERN_MIGRATEURS_DEUXCOTES_5_COUTEAUX), 
            new Pattern(PATTERN_DOUBLE_REBONDS)
        }, 
        { // angry
            new Pattern(PATTERN_MIGRATEURS_DEUXCOTES_5_COUTEAUX), 
            new Pattern(PATTERN_DELUGE_LAMES_HAUT_BASIQUE), 
            new Pattern(PATTERN_DELUGE_LAMES_BAS_BASIQUE), 
            new Pattern(PATTERN_ROUTE_DEUX_SENS_INVERSE), 
            new Pattern(PATTERN_ROUTE_DEUX_SENS), 
            new Pattern(PATTERN_MURS_DEUX_COTES), 
            new Pattern(PATTERN_MIGRATEURS_GAUCHE_5_COUTEAUX), 
            new Pattern(PATTERN_MIGRATEURS_DROITE_5_COUTEAUX)
        }, 
        { // ireful
            new Pattern(PATTERN_DELUGE_LAMES_HAUT_BASIQUE), 
            new Pattern(PATTERN_DELUGE_LAMES_BAS_BASIQUE), 
            new Pattern(PATTERN_ROUTE_DEUX_SENS_INVERSE), 
            new Pattern(PATTERN_ROUTE_DEUX_SENS), 
            new Pattern(PATTERN_MURS_DEUX_COTES),
            new Pattern(PATTERN_CASCADE_COUTEAUX_SEPARATION),
            new Pattern(PATTERN_HOLA_GAUCHE),
            new Pattern(PATTERN_HOLA_DROITE)
        },
        { // mad
            new Pattern(PATTERN_DELUGE_LAMES_HAUT_BASIQUE), 
            new Pattern(PATTERN_DELUGE_LAMES_BAS_BASIQUE), 
            new Pattern(PATTERN_ROUTE_DEUX_SENS_INVERSE), 
            new Pattern(PATTERN_ROUTE_DEUX_SENS), 
            new Pattern(PATTERN_MURS_DEUX_COTES),
            new Pattern(PATTERN_HOLA_GAUCHE),
            new Pattern(PATTERN_HOLA_DROITE),
            new Pattern(PATTERN_DOUBLE_HOLA)
        },
        { // unleashed
            new Pattern(PATTERN_ROUTE_DEUX_SENS_INVERSE), 
            new Pattern(PATTERN_ROUTE_DEUX_SENS), 
            new Pattern(PATTERN_MURS_DEUX_COTES),
            new Pattern(PATTERN_HOLA_GAUCHE),
            new Pattern(PATTERN_HOLA_DROITE),
            new Pattern(PATTERN_DOUBLE_HOLA),
            new Pattern(PATTERN_CROIX_RAPIDE),
            new Pattern(PATTERN_DOUBLE_EVENTAIL)
        },
        { // furious
            
            new Pattern(PATTERN_BOOMERANG_RAPIDE_4_3),
            new Pattern(PATTERN_MIGRATEURS_DEUXCOTES_5_COUTEAUX),
            new Pattern(PATTERN_CASCADE_COUTEAUX_SEPARATION),
            new Pattern(PATTERN_CROIX_RAPIDE),
            new Pattern(PATTERN_DOUBLE_HOLA),
            new Pattern(PATTERN_MURS_DEUX_COTES),
            new Pattern(PATTERN_DOUBLE_EVENTAIL),
            new Pattern(PATTERN_BOOMERANG_RAPIDE_4_3),
        }
    };

    Pattern pattern;

    final float DUREE_ENERVE_SUPPLEMENTAIRE = 0;
    final float TEMPS_REACTION = 0.8f;
    float duree_lancement_pattern;

    GenerateurCouteau gc;

    float duree_pat_actuel;
    float temps;

    Cuisinier()
    {
        super(new Vecteur(242, 58), new Image(IMAGE_CUISINIER, 5, 0.01f, ANIMATION_CUISINIER_NORMAL, true));
        temps = 4;
        choisir_pattern();
        gc = new GenerateurCouteau();
    }

    public void mettre_a_jour()
    {
        super.mettre_a_jour();

        temps--;
        if ( temps <= 0) // d\u00e9lais entre les attaques atteint
        {
            if (temps == 0) // premi\u00e8re frame de l'animation d'attaque
            {
                trembler(2, DUREE_ENERVE_SUPPLEMENTAIRE, false);
                image.changerAnimation(ANIMATION_CUISINIER_ENERVE, 0.3f, false, true, true);
            }

            if ( temps == - TEMPS_REACTION  * IMAGES_PAR_SECONDE)	// lancement du pattern
            {
                choisir_pattern();
                pattern.initialiser(new Vecteur(0, 0));

                /*for ( int i = 0; i < 5; i++ )
                 {
                 couteaux.add(new Couteau(c.genererPosition(), c.genererCible()));
                 }*/
            }

            if (pattern.en_cours)
            {
                pattern.mettre_a_jour();
            }

            if (temps < -duree_lancement_pattern)
            {
                temps = DIFF_delais_patterns * IMAGES_PAR_SECONDE;
                image.changerAnimation(ANIMATION_CUISINIER_NORMAL, 0.01f, false, true, true);
            }
        } else
        {
            gc.mettre_a_jour();
        }
    }


    public void choisir_pattern()
    {
        int i = (int) random(PATTERNS[DIFF_niveau_patterns].length);
        pattern = PATTERNS[DIFF_niveau_patterns][i];

        duree_pat_actuel = pattern.duree();

        duree_lancement_pattern = (TEMPS_REACTION + DUREE_ENERVE_SUPPLEMENTAIRE) * IMAGES_PAR_SECONDE + duree_pat_actuel;
    }


    public void afficher()
    {
        super.afficher();

        if ( temps <= 0)
        {
            float opacite = sin((temps * TWO_PI) / ((duree_lancement_pattern / IMAGES_PAR_SECONDE) * 20));
            ecran.fill(255, 0, 0, 24 * opacite);
            //    ecran.rect(0, 0, LARGEUR_ECRAN, HAUTEUR_ECRAN);
            ecran.rect(0, HAUTEUR_BANDEAU, LARGEUR_PLANCHE, HAUTEUR_PLANCHE);
        }
    }
}


class Pattern
{
    int temps; // le temps depuis le lan\u00e7ement du pattern
    int avancement; // le nombre de couteaux du pattern d\u00e9j\u00e0 lanc\u00e9s

    boolean en_cours; // le pattern est en train d'\u00eatre lanc\u00e9 (mis \u00e0 jour)

    Couteau[] cts;
    int[] delais;
    Vecteur decalage;

    Couteau c;

    /*
    	Cr\u00e9e un pattern
     
     	- Les deux tableaux doivent avoir la m\u00eame taille
     	- Les d\u00e9lais correspondent aux moment ou les couteaux sont lanc\u00e9s \u00e0 partir du lan\u00e7ement du pattern (en ticks)
     	- Les d\u00e9lais doivent \u00eatre indiqu\u00e9s par ordre croissant;
     */
    Pattern(float[][] p)
    {
        delais = new int[p.length];
        cts = new Couteau[p.length];

        for (int i = 0; i < p.length; i++)
        {
            delais[i] = (int) p[i][0];
            c = new Couteau(new Vecteur(16.5f + p[i][1] * 33, HAUTEUR_BANDEAU + 16.5f + p[i][2] * 33), new Vecteur(16.5f + p[i][3] * 33, HAUTEUR_BANDEAU + 16.5f + p[i][4] * 33));
            c.modifierAcceleration(p[i][5], p[i][6]);
            c.modifierVitesse(p[i][7]);
            cts[i] = c;
        }
    }


    public void initialiser(Vecteur decalage)
    {
        this.decalage = decalage;
        temps = 0;
        avancement = 0;
        en_cours = true;
    }


    public void mettre_a_jour()
    {
        while (delais[avancement] <= temps)
        {
            creer_couteau(cloner_couteau(cts[avancement++]));

            if (avancement >= delais.length)
            {
                stopper();
                return;
            }
        }

        temps++;
    }


    public void stopper()
    {
        en_cours = false;
    }


    public void creer_couteau(Couteau c)
    {
        this.c = c;
        couteaux.add(c);
    }


    /*
    	Retourne une copie d'un objet couteau (/!\ Fonction lente \u00e0 utiliser le moins souvent possible)
     */
    public Couteau cloner_couteau(Couteau c)
    {
        Couteau cl = new Couteau(new Vecteur(c.position.x, c.position.y), new Vecteur(c.position_cible.x, c.position_cible.y));
        cl.modifierAcceleration(c.acceleration.x, c.acceleration.y);
        cl.modifierVitesse(c.vitesse.longueur());
        return cl;
    }


    public int duree()
    {
        return delais[delais.length-1] + (int)( LARGEUR_PLANCHE / cts[cts.length-1].vitesse.longueur());
    }
}
/* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
 *   Furious Tomato - Par Benjamin Strabach, Valentin Galerne et Simon Rozec   *
 *                                                                             *
 *                ~ Fichier de gestion de la difficult\u00e9 du jeu ~               *
 * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * */
 

final String[] PALIERS = {"...", "Salty", "Nervous", "Angry", "Ireful", "Mad", "Unleashed", "Furious !!!"};
//final float[] TEMPS_PALIERS = {5, 10, 15, 20, 25 ,30, 35};

final float[] TEMPS_PALIERS = {11.5f, 31.5f, 51, 79, 108 ,145, 184.5f};

int palier_actuel;

float DIFF_delais_patterns = 10;
int DIFF_niveau_patterns = 1;

float DIFF_delais_couteaux;
float DIFF_vitesse_couteaux;
boolean DIFF_couteaux_derives;

float DIFF_delais_sel = 10;
float DIFF_surface_sel = 64 * 48;
float DIFF_duree_vie_sel = 6;
float DIFF_quantite_sel;

float DIFF_cout_endurance_impulsion = 100 / 4;

final float[][] STATS_PALIERS =                    // VALEURS A MODIFIER
{
    {12,    0,        1.8f,    1.5f,    0,        0,        48*48,    8,        0,        100/2},        //1- ...
    {10,    1,        1.8f,    1.5f,    0,        10,       48*48,    8,        0.5f,        100/3},        //2- Salty
    {10,    2,        1.7f,    1.7f,    0,        10,       52*52,    8,        0.5f,        100/4},        //3- Nervous
    {12,    3,        1.4f,    2,      0,        9,        52*52,    9,        0.5f,        100/5},        //4- Angry
    {62,    4,        1,      1.2f,    1,        9,        52*52,    9,        0.6f,        100/7},        //5- Ireful
    {8,     5,        0.6f,    0.8f,    0,        0.2f,      96*96,    1,       0.1f,        100/10},        //6- Mad
    {6,     6,        0.7f,    2.6f,    0,        8,        60*60,    10,        0.4f,        100/15},        //7- Unleashed
    {5,     7,        0.6f,    1.5f,    1,        8,        96*96,    10,        0.2f,        100/20},        //8- Furious !!!
};


public void initialiser_difficulte()
{
   palier_actuel = 0;
   modifier_stats_difficulte();
}


public void mettre_a_jour_difficulte()
{
    if(palier_actuel < 7 && temps_partie >= TEMPS_PALIERS[palier_actuel]) {
        palier_actuel += 1;
        modifier_stats_difficulte();
        ap.montrer_palier();
    }
}

public void modifier_stats_difficulte()
{
    DIFF_delais_patterns = STATS_PALIERS[palier_actuel][0];
    DIFF_niveau_patterns = PApplet.parseInt(STATS_PALIERS[palier_actuel][1]);
    DIFF_delais_couteaux = STATS_PALIERS[palier_actuel][2];
    DIFF_vitesse_couteaux = STATS_PALIERS[palier_actuel][3];
    DIFF_couteaux_derives = PApplet.parseBoolean( (int) STATS_PALIERS[palier_actuel][4]);
    DIFF_delais_sel  = STATS_PALIERS[palier_actuel][5];
    DIFF_surface_sel = STATS_PALIERS[palier_actuel][6];
    DIFF_duree_vie_sel = STATS_PALIERS[palier_actuel][7];
    DIFF_quantite_sel = STATS_PALIERS[palier_actuel][8];
    DIFF_cout_endurance_impulsion = STATS_PALIERS[palier_actuel][9];
}

class AffichagePalier
{
    float opacite;
    float vitesse_degrade_palier = 255 / (IMAGES_PAR_SECONDE * 2);
    String nom_palier;
    float taille_texte = 64;
    
    AffichagePalier()
    {
        opacite = 0;
        nom_palier = PALIERS[0];
    }

    public void mettre_a_jour()
    {
        if(opacite > 0) 
        {
          opacite -= vitesse_degrade_palier;
          taille_texte *= 0.99f;
        }
    }
    
    public void dessiner()
    {
        ecran.textSize(taille_texte);
        ecran.fill(255, opacite);
        ecran.textAlign(CENTER, CENTER);
        ecran.text(nom_palier, LARGEUR_PLANCHE / 2, HAUTEUR_BANDEAU + HAUTEUR_PLANCHE / 2 - 14);
    }
    
    public void montrer_palier()
    {
       opacite = 255;
       taille_texte = 64;
       nom_palier = PALIERS[palier_actuel];
       (voix_paliers[palier_actuel - 1]).trigger();
    }
}
/* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
 *   Furious Tomato - Par Benjamin Strabach, Valentin Galerne et Simon Rozec   *
 *                                                                             *
 *                          ~ Initialisation de l'\u00e9cran ~                      *
 * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *  */

PGraphics ecran;

public void initialiser_ecran()
{
  ecran = createGraphics(LARGEUR_ECRAN, HAUTEUR_ECRAN);
  ecran.beginDraw();
  ecran.noStroke();
  ecran.noSmooth();
  ecran.endDraw();
}



class Tremblement
{
  float amplitude;
  float duree;
  float temps;
  boolean decrementer;

  float multiplieur = 1;

  Tremblement(float a, float d, boolean dec)
  {
    amplitude = a;
    duree = d;
    decrementer = dec;

    temps = 0;

    if (dec)
    {
      multiplieur = exp((log(1/a)-10)/(d * IMAGES_PAR_SECONDE));
    }
  }

  public void mettre_a_jour()
  {
    if (decrementer) amplitude *= multiplieur;
    
    temps++;

    if (temps < duree * IMAGES_PAR_SECONDE)
    {
      float moitie_amp = amplitude / 2;
      translate(random(-moitie_amp, moitie_amp), random(-moitie_amp, moitie_amp));
    }
  }
}


public void trembler(float amp, float duree, boolean decrementation)
{
  tremblement = new Tremblement(amp, duree, decrementation);
}


public void supprimer_tremblement()
{
  tremblement = initialiser_tremblement();
}


public Tremblement initialiser_tremblement()
{
  return new Tremblement(0, 0, false);
}
/* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
 *   Furious Tomato - Par Benjamin Strabach, Valentin Galerne et Simon Rozec   *
 *                                                                             *
 *                    ~ Fichier de description des entit\u00e9s ~                   *
 * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * */

ArrayList<Entite> entites = new ArrayList<Entite>();

class Entite
{
    Vecteur position;
    Vecteur vitesse;
    Vecteur acceleration;

    Image image;

    boolean morte;
    boolean visible;

    float rayon_collision;
    Vecteur decalage_collision;
    boolean afficher_collision;

    Entite(Vecteur position, Image image)
    {
        this.position = position;
        vitesse = new Vecteur(0, 0);
        acceleration = new Vecteur(0, 0);

        this.image = image;

        morte = false;
        visible = true;
    }


    public void detruire()
    {
        entites.remove(this);
	}


    public void mettre_a_jour()
    {
        this.position.ajouter(vitesse);
        this.vitesse.ajouter(acceleration);

        image.mettre_a_jour();

        if (morte)
        {
            detruire();
        }
    }


    public void parametrer_collision(float rayon, Vecteur decalage, boolean afficher)
    {
        rayon_collision = rayon;
        decalage_collision = decalage;
        afficher_collision = afficher;
    }


    public boolean collision(Entite e)
    {
        return dist(position.x + decalage_collision.x, position.y + decalage_collision.y, e.position.x + e.decalage_collision.x, e.position.y + e.decalage_collision.y) < (rayon_collision + e.rayon_collision) * .5f;
    }
    
    
    public void modifierAcceleration(float x, float y)
    {
   		acceleration.x = x;
   		acceleration.y = y;
    }
    
    
    public void modifierVitesse(float v)
    {
    	vitesse.modifierAL(vitesse.direction(), v);
    }


    public void afficher()
    {
        if (visible)
        {
            image.afficher(position.x, position.y);

            if (afficher_collision)
            {
                ecran.fill(color(255, 100, 100, 160));
                ecran.ellipse(position.x + decalage_collision.x, position.y + decalage_collision.y, rayon_collision, rayon_collision);
            }

            if (AFFICHER_MOUVEMENT) // affichage du vecteur vitesse et acceleration
            {
                ecran.stroke(0xff0000ff);
                ecran.line(position.x, position.y, position.x + vitesse.x * 10, position.y + vitesse.y * 10);
                ecran.stroke(0xffff0000);
                ecran.line(position.x, position.y, position.x + acceleration.x * 200, position.y + acceleration.y * 200);
                ecran.noStroke();
            }
        }
    }
}
/* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
 *   Furious Tomato - Par Benjamin Strabach, Valentin Galerne et Simon Rozec   *
 *                                                                             *
 *                   ~ Fichier de gestion des entr\u00e9es clavier ~                *
 * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *  */

boolean[] touches = new boolean[600]; // tableau contenant les \u00e9tats des touches

boolean touche_pressee = false; // = true si une touche est press\u00e9e pendant la frame
boolean touche_relachee = false; // = true si une touche est rel\u00e2ch\u00e9e pendant la frame


public void keyPressed()
{
  touches[keyCode] = true;
  touche_pressee = true;
}


public void keyReleased()
{
  touches[keyCode] = false;
  touche_relachee = true;
}


public void mettre_a_jour_entrees()
{
  touche_pressee = false;
  touche_relachee = false;
} 
/* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
 *   Furious Tomato - Par Benjamin Strabach, Valentin Galerne et Simon Rozec   *
 *                                                                             *
 *                       ~ Fichier de gestion des images ~                     *
 * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *  */

/*
    Cette classe correspond \u00e0 une image destin\u00e9e \u00e0 \u00eatre affich\u00e9e dans le jeu. Cette image peut \u00eatre anim\u00e9e
 */
class Image
{
  PImage[] images; // sous images
  int[] animation; // encha\u00eenement des sous images (index)

  boolean animee; // d\u00e9filement des sous images activ\u00e9
  boolean boucler_animation;
  boolean miroir_x = false;
  boolean miroir_y = false;

  int index_image; // l'index de la sous image actuelle

  float vitesse_animation; // pourcentage de vitesse de changement des images (1 = 1 frame par tick)
  float opacite = 255; // opacit\u00e9 de l'image

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
    	Cr\u00e9e une image anim\u00e9e \u00e0 partir d'une seule image contenant toutes les \u00e9tapes de l'animation plac\u00e9es les unes \u00e0 la suite des autres
   */
  Image(String fichier, int nb_images, float vitesse_animation, int[] animation, boolean boucler_animation)
  {
    PImage image = loadImage("images/" + fichier); // chargement de l'image globale

    images = new PImage[nb_images]; // cr\u00e9ation d'un tableau de sous images

    // d\u00e9finition de la taille des sous images
    int case_h = image.height;
    int case_l = image.width / nb_images;

    for (int i = 0; i < nb_images; i++) // on boucle autant de fois qu'il doit y avoir de sous images
    {
      PImage sous_image = createImage(case_l, case_h, ARGB); // cr\u00e9ation d'une sous image vide

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
   	Cr\u00e9e une image fixe
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
   	Cr\u00e9e une image fixe \u00e0 partir d'une PImage
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
  public void mettre_a_jour()
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
		Affiche l'image aux coordonn\u00e9es x et y indiqu\u00e9es
   */
  public void afficher(float x, float y)
  {   

    ecran.pushMatrix();

    ecran.translate(x, y);
    ecran.rotate(angle);

    if (miroir_x || miroir_y)
    {
      ecran.scale((miroir_x) ? -1 : 1, (miroir_y) ? -1 : 1);
      ecran.translate(((miroir_x) ? -largeur : 0), 
                     ((miroir_y) ? -hauteur : 0));
    }		

    ecran.tint(255, opacite);
    ecran.image(actuelle(), ((miroir_x) ? 1 : -1) * origine_x, 
                            ((miroir_y) ? 1 : -1) * origine_y
               );

    ecran.popMatrix();
  }


  /*
        Retourne l'image actuelle de l'animation
   */
  public PImage actuelle()
  {
    return images[animation[index_image]];
  }


  /*
        Retourne une sous-image \u00e0 un index pr\u00e9cis
   */
  public PImage index(int index)
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
  public boolean animation_finie()
  {
    return (!boucler_animation) && (index_image == longueur_animation - 1);
  }


  /*
        Change l'animation attribu\u00e9e \u00e0 l'image
   */
  public void changerAnimation(int[] animation, float vitesse_animation, boolean restart, boolean retour_debut, boolean boucler_animation)
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
		Change la vitesse \u00e0 laquelle se d\u00e9roule l'animation
   	*/
  public void changerVitesseAnimation(float vitesse_animation)
  {
    this.vitesse_animation = vitesse_animation;
    animation_finie = false;
  }


  /*
		Fait boucler ou non l'animation
   	*/
  public void faireBouclerAnimation(boolean boucler_animation)
  {
    this.boucler_animation = boucler_animation;
  }


  /*
    	Modifie l'opacit\u00e9 de l'image
   */
  public void opacite(float o)
  {
    opacite = o;
  }


  /*
    	Modifie l'angle de l'image
   */
  public void angle(float a)
  {
    angle = a;
  }


  /*
		Modifie le point d'origine de l'image
   	*/
  public void origine(float x, float y)
  {
    origine_x = x;
    origine_y = y;
  }
}
/* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
 *   Furious Tomato - Par Benjamin Strabach, Valentin Galerne et Simon Rozec   *
 *                                                                             *
 *                     ~ Gestion de l'\u00e9cran d'introduction ~                   *
 * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * */

boolean intro_init = false;

float opacite_intro = -100;
float degrade_speed_intro = 255 / (IMAGES_PAR_SECONDE);

boolean son_joue = false; // le son de l'intro a \u00e9t\u00e9 jou\u00e9

Image logo;


public void initialiser_intro()
{
    logo = new Image(IMAGE_LOGO_INTRO);
}


public void mettre_a_jour_intro()
{
    if (opacite_intro > 400)
    {
        degrade_speed_intro = - 255 / (IMAGES_PAR_SECONDE * 1.5f);
        
        if(!son_joue)
        {
            son_intro.trigger();
        	son_joue = true;	   
        }
    }

    if (opacite_intro < -100 || touches[TOUCHE_VALIDER] || touches[TOUCHE_IMPULSION])
    {
        terminer_intro();
    }

    opacite_intro += degrade_speed_intro;
}


public void dessiner_intro()
{
    ecran.fill(0);
    ecran.rect(0, 0, LARGEUR_ECRAN, HAUTEUR_ECRAN);

    logo.opacite = opacite_intro;
    logo.afficher(LARGEUR_ECRAN  / 2 - logo.largeur / 2, HAUTEUR_ECRAN / 2 - logo.hauteur / 2);
}


public void terminer_intro()
{
    scene = SCENES[MENU];
    intro_init = false;
}
/* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
 *   Furious Tomato - Par Benjamin Strabach, Valentin Galerne et Simon Rozec   *
 *                                                                             *
 *                    ~ Gestion de l'\u00e9cran en cours de partie ~                *
 * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * */

boolean jeu_init = false;



int temps_partie;

Image gui;
Image planche;
Image imge;
Image mscore;

CompteARebours compte_a_rebours;

AffichagePalier ap;

Cuisinier cuisinier;

AfficheurLCD lcd;
AfficheurLCD mslcd;

Joueur joueur; // une r\u00e9f\u00e9rence vers le joueur
Saliere saliere; // une r\u00e9f\u00e9rence vers la sali\u00e8re

public void initialiser_jeu()
{
    
    retour_active = false;

    temps_partie = 0;
    gui = new Image(IMAGE_INTERFACE);
    planche = new Image(IMAGE_PLANCHE);

    compte_a_rebours = new CompteARebours();
    ap = new AffichagePalier();

    cuisinier = new Cuisinier();
    saliere = new Saliere();

    joueur = new Joueur(new Vecteur(64, 64));
    joueur.visible = false;


    entites.clear();
    couteaux.clear();
    sel.clear();

    lcd = new AfficheurLCD(LCD_TYPE_SCORE);
    mslcd = new AfficheurLCD(LCD_TYPE_MEILLEUR_SCORE);

    initialiser_difficulte();

    charger_score();
    
    mscore = mslcd.generer_image(Integer.parseInt(meilleur_score));
    
    musique_menu.pause();
    musique_menu.rewind();
    musique_partie.loop();
}


public void mettre_a_jour_jeu()
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

    mettre_a_jour_difficulte();
    ap.mettre_a_jour();

    joueur.ralenti = false;

    for (int i = 0; i < entites.size(); i++)
    {
        Entite e = entites.get(i);
        e.mettre_a_jour();


        if (e instanceof Sel)
        {
            ((Sel) e).collision(joueur);
        }
    }


    for (int i = 0; i < sel.size(); i++)
    {
        Sel s = sel.get(i);
        s.mettre_a_jour();

        s.collision(joueur);
    }

    joueur.mettre_a_jour();

    //Mise \u00e0 jour des couteaux
    for (int i = 0; i < couteaux.size(); i++)
    {
        Couteau c = couteaux.get(i);
        c.mettre_a_jour();

        if (COLLISIONS_COUTEAUX)
        {
            c.collision(joueur);
        }
    }

    saliere.mettre_a_jour();
    cuisinier.mettre_a_jour();
}


public void dessiner_jeu()
{
    gui.afficher(0, 0);
    planche.afficher(0, 50);

    imge = lcd.generer_image( (int) temps_partie);


    ecran.image(imge.actuelle(), 71, 10);
	ecran.image(mscore.actuelle(), 196, 29);

    for (int i = 0; i < entites.size(); i++)
    {
        Entite e = entites.get(i);
        e.afficher();
    }

    // Affichage des grains de sel
    for (int i = 0; i < sel.size(); i++)
    {
        Sel s = sel.get(i);
        s.afficher();
    }

    joueur.afficher();

    // Affichage des couteaux
    ecran.clip(0, HAUTEUR_BANDEAU, LARGEUR_PLANCHE, HAUTEUR_PLANCHE);
    for (int i = 0; i < couteaux.size(); i++)
    {
        Couteau c = couteaux.get(i);
        c.afficher();
    }
    ecran.noClip();

    saliere.afficher();
    cuisinier.afficher();

    compte_a_rebours.dessiner();
    ap.dessiner();
}


public void terminer_jeu()
{
    supprimer_tremblement();
    scene = SCENES[FIN];
    jeu_init = false;
}



/*
	Compte \u00e0 rebours de d\u00e9but de partie et animation de l'arriv\u00e9e du joueur dans l'\u00e9cran
 */
class CompteARebours
{
    final float taille_texte_base = 64;

    boolean fini = false; // = true quand le compte \u00e0 rebours est termin\u00e9 (au moment de l'affichage du "courez !!!")
    boolean cacher = false; // = true quand le compte \u00e0 rebours est cach\u00e9
    float opacite_compte_a_rebours = 255;
    float vitesse_degrade_compte_a_rebours = 255 / IMAGES_PAR_SECONDE;
    int a = 3;
    String texte;
    float taille_texte = 64;

    // Animation tomate
    final float DUREE_ANIMATION = (int) (IMAGES_PAR_SECONDE * (6.0f/6.0f));
    final float X_TOMATE_DEBUT = LARGEUR_PLANCHE + 24; //tailletomate;
    final float X_TOMATE_FIN = LARGEUR_PLANCHE / 2;
    final float Y_TOMATE_DEBUT = HAUTEUR_PLANCHE / 3;
    final float Y_TOMATE_FIN = HAUTEUR_ECRAN - 24 * 2;

    float temps_animation = 0;
    float x_tomate = X_TOMATE_DEBUT;
    float y_tomate = Y_TOMATE_DEBUT;

    Image tomate_saut;
	Image tutoriel;

    CompteARebours()
    {
        tomate_saut = new Image(IMAGE_TOMATE_SAUT, 3, 0, ANIMATION_TOMATE_SAUT, false);
        tomate_saut.origine(tomate_saut.largeur / 2, tomate_saut.hauteur / 2);
    	
    	tutoriel = new Image(IMAGE_TUTORIEL);
    	tutoriel.origine(tutoriel.largeur / 2, tutoriel.hauteur / 2);
	}

    public void mettre_a_jour()
    {

        if (cacher) 
        {
            return;
        }

        opacite_compte_a_rebours -= vitesse_degrade_compte_a_rebours;

        if (texte != "Courez !!!")
            taille_texte *= 0.99f;
        else
            taille_texte *= 0.995f;



        if (a == 1 && opacite_compte_a_rebours <= 250 * (DUREE_ANIMATION / IMAGES_PAR_SECONDE) )
        {
            temps_animation++;
            tomate_saut.mettre_a_jour();

            float pourcentage_anim = temps_animation / DUREE_ANIMATION;

            if (temps_animation <= DUREE_ANIMATION * 0.5f)
            {
                tomate_saut.angle(tomate_saut.angle - TWO_PI / (DUREE_ANIMATION * 0.5f));
            }

            if (temps_animation == (int) (DUREE_ANIMATION * 0.5f))
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
                trembler(40, .4f, true);

                // ajout de particule pour accentuer l'effet de choc avec le sol
                for (int i = 0; i < 30; i++)
                {
                    Vecteur vitesse = new Vecteur(0, 0);
                    vitesse.modifierAL(random(0, TWO_PI), 2);

                    float acceleration = random(0.85f, 0.9f);

                    entites.add(0, new Particule(new Vecteur(x_tomate + tomate_saut.largeur / 2, y_tomate + tomate_saut.hauteur), 
                        vitesse, 
                        new Vecteur(acceleration, acceleration - 0.06f), 
                        0xffC1ACA0, 
                        random(0.6f, 0.9f), 
                        (int) random(3, 4)
                        ));
                }
            }

            if (a == -1) cacher = true;
        }
    }

    public void dessiner()
    {   
        if (cacher)
        {
            return;
        }

        ecran.textSize(taille_texte);

        if (a > 0)
        {
            texte = "" + a;
        } else
        {
            ecran.textSize(taille_texte - 16);
            texte = "Courez !!!";
        }

        if (!fini)
        {
            float pourcentage_anim = temps_animation / DUREE_ANIMATION;

            ecran.clip(0, HAUTEUR_BANDEAU, LARGEUR_PLANCHE, HAUTEUR_PLANCHE);

            // affichage de l'ombre du joueur
            ecran.fill(color(0, 0, 0, 30));
            ecran.noStroke();
            ecran.ellipse(x_tomate + tomate_saut.largeur / 2, Y_TOMATE_FIN + tomate_saut.hauteur, (tomate_saut.largeur - 7) * pourcentage_anim, (tomate_saut.hauteur / 2 - 5) * pourcentage_anim); // dessin de l'ombre

            tomate_saut.afficher(x_tomate + tomate_saut.origine_x, y_tomate + tomate_saut.origine_y);

            ecran.noClip();
        }

        ecran.fill(255, opacite_compte_a_rebours);
        ecran.textAlign(CENTER, CENTER);
        ecran.text(texte, LARGEUR_PLANCHE / 2, HAUTEUR_BANDEAU + HAUTEUR_PLANCHE / 2 - 32); // 14
        
        if(texte == "Courez !!!")
        {
        	tutoriel.opacite = opacite_compte_a_rebours;
        }
        else
        {
        	tutoriel.opacite = 255;   
        }
        
        tutoriel.afficher(LARGEUR_PLANCHE / 2, HAUTEUR_BANDEAU + HAUTEUR_PLANCHE / 2 + 24);
    }


    /*
		Equation de la trajectoire du saut du joueur en d\u00e9but de partie
     	*/
    public float fonction_saut(float x)
    {
        return pow(x, 3)+(1-sqrt(x))/2;
    }
}
/* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
 *   Furious Tomato - Par Benjamin Strabach, Valentin Galerne et Simon Rozec   *
 *                                                                             *
 *                        ~ Fichier de gestion du joueur ~                     *
 * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * */

class Joueur extends Entite
{
    final float VIT_DEP_NORMAL = 2;
    final float VIT_DEP_RALENTI = .8f;
    final float VIT_DEP_IMPULSION = 20;

    final int ENDURENCE_MAX = 100;
    final float DUREE_AFFICHAGE_ENDURENCE = 3;

    final float DUREE_IMPULSION = 0.05f;


    boolean perdu = false;

    float angle; // direction du joueur	  

    float vit_dep = VIT_DEP_NORMAL; // vitesse de d\u00e9placement


    boolean impulsion = false;
    boolean impulsion_disponible = false;
    int temps_debut_impulsion;

    float delais_recuperation;
    float temps_inactif;

    float endurance;
    float endurance_affichee;
    float opacite_endurance;
    int temps_endurance;
    boolean endurance_visible;
    boolean afficher_endurance; // pareil qu'endurance_visible mais en tout ou rien (ignore le fade)
    boolean endurance_regeneration = false;


    boolean immobile = false;
    float moment_arret = 0;

    boolean ralenti = false;
    boolean epuise = false;

    float axeX = 0; // dose de d\u00e9placement en X : -1 < x < 1
    float axeY = 0; // dose de d\u00e9placement en Y : -1 < y < 1

    final float VITESSE_ANIMATION_COURIR = 0.3f;

    Joueur(Vecteur pos)
    {
        super(pos, new Image(IMAGE_TOMATE, 20, 0.4f, ANIMATION_TOMATE_PROFIL_FACE, true));
        parametrer_collision(image.largeur / 1.8f, new Vecteur(image.largeur / 2, 2 * image.hauteur / 3), AFFICHER_COLLISIONS);
        perdu = false;

        endurance = ENDURENCE_MAX;
        endurance_affichee = endurance;
        opacite_endurance = 2;
        endurance_visible = true;
    }

    public void mettre_a_jour()
    {
        super.mettre_a_jour();

        if (!perdu)
        {
            // Gestion des d\u00e9placements du joueur
            axeX = 0;
            axeY = 0;

            if (touches[TOUCHE_GAUCHE])  axeX += 1;
            if (touches[TOUCHE_DROITE]) axeX += -1;
            if (touches[TOUCHE_HAUT])    axeY += -1;
            if (touches[TOUCHE_BAS])  axeY += 1;

            if (axeX == 0 && axeY == 0)
            {
                vit_dep = 0;
                if (!immobile)
                {
                    moment_arret = temps_global; 
                    immobile = true;
                }
            } else
            {
                immobile = false;

                if (impulsion)
                {
                    vit_dep = VIT_DEP_IMPULSION;
                } else if (ralenti || epuise)
                {
                    vit_dep = VIT_DEP_RALENTI;
                } else
                {
                    vit_dep = VIT_DEP_NORMAL;
                }

                angle = atan2(axeX, axeY);
            }


            vitesse.modifierAL(angle + PI/2, vit_dep);

            // Collisions avec les bords de la planche
            if (position.x < 0) 
            {
                position.x = 0;
                vitesse.x = 0;
            }

            if (position.x > 218 - image.largeur / 2)
            {
                position.x = 218 - image.largeur / 2;
                vitesse.x = 0;
            }

            if (position.y > HAUTEUR_ECRAN - image.hauteur - 10)
            {
                position.y = HAUTEUR_ECRAN - image.hauteur - 10;
                vitesse.y = 0;
            }

            if (position.y < 37)
            {
                position.y = 37;
                vitesse.y = 0;
            }


            // impulsion
            if (touches[TOUCHE_IMPULSION]) 
            {
                if (impulsion)
                {
                    entites.add(new FantomeJoueur(new Vecteur(position.x + vitesse.x, position.y + vitesse.y), new Image(image.actuelle()), image.miroir_x));

                    if (temps_global - temps_debut_impulsion > DUREE_IMPULSION * IMAGES_PAR_SECONDE)
                    {
                        impulsion = false;
                    }
                } else if (impulsion_disponible && !immobile && !epuise)
                {
                    impulsion = true;
                    impulsion_disponible = false;
                    temps_debut_impulsion = temps_global;
                    endurance -= DIFF_cout_endurance_impulsion;
                    son_impulsion.trigger();
                }
            } else
            {
                impulsion = false;
                impulsion_disponible = true;
            }



            // Gestion de l'animation du joueur

            image.miroir_x = angle > 0 && angle < PI;

            if (angle == 0) // le personnage va vers le bas
            {
                image.changerAnimation(ANIMATION_TOMATE_FACE, VITESSE_ANIMATION_COURIR, false, false, true);
            } else if (angle == -PI/2 || angle == -PI/4 || angle == PI/2 || angle == PI/4)  // le personnage va vers le bas en diagonale
            {
                image.changerAnimation(ANIMATION_TOMATE_PROFIL_FACE, VITESSE_ANIMATION_COURIR, false, false, true);
            } else if (angle == PI)  // le personnage va vers le haut 
            {
                image.changerAnimation(ANIMATION_TOMATE_DOS, VITESSE_ANIMATION_COURIR, false, false, true);
            } else if (angle == -3*PI/4 || angle == 3*PI/4)  // le personnage va vers le haut en diagonale
            {
                image.changerAnimation(ANIMATION_TOMATE_PROFIL_DOS, VITESSE_ANIMATION_COURIR, false, false, true);
            }

            if (vitesse.longueur() == 0)
            {
                image.changerVitesseAnimation(0);
                image.index_image = 0;
            } else 
            {
                image.changerVitesseAnimation(VITESSE_ANIMATION_COURIR);
            }

			// si le joueur est dans le sel
            if (ralenti)
            {
                if (temps_global % 16 == 0) // son des pas du joueur dans le sel
                {
                    son_sel_pas.trigger();   
                }
            }


            if (immobile && (temps_global - moment_arret) > IMAGES_PAR_SECONDE)
            {
                endurance_regeneration = true;
            } else
            {
                endurance_regeneration = false;
            }

            if (endurance_regeneration && temps_global % 2 == 0)
            {
                endurance += 2;
            }


            // gestion de l'\u00e9puisement du joueur
            if (endurance <= 0)
            {
                epuise = true;
            }

            if (epuise && endurance >= ENDURENCE_MAX / 2)
            {
                epuise = false;
            }

            if (epuise)
            {
                if (temps_global % (int)(IMAGES_PAR_SECONDE / random(1, 5)) == 0)
                {
                    entites.add(new GoutteEau(new Vecteur(position.x + random(0, image.largeur), position.y + 5)
                        ));
                }
            }


            endurance = max(0, endurance);
            endurance = min(ENDURENCE_MAX, endurance);
            
            // variation progressive de l'endurance affich\u00e9e
            if (endurance_affichee < endurance) endurance_affichee ++;
            if (endurance_affichee > endurance) endurance_affichee --;

            if (endurance != endurance_affichee)
            {
                endurance_visible = true;
            }
            else if (temps_endurance == -1 && endurance_visible)
            {
                temps_endurance = temps_global;
            }
            else if ((temps_global - temps_endurance > DUREE_AFFICHAGE_ENDURENCE * IMAGES_PAR_SECONDE) 
                         && endurance_visible)
            {
                temps_endurance = -1;
                endurance_visible = false;
            }
        } else if (image.animation_finie()) // si le joueur est morte et que son animation de mort est finie
        {
            x_mort = position.x;
            y_mort = position.y;
            terminer_jeu();
        }
    }

    public void afficher()
    {
        if (!visible)
        {
            return;
        }

        // d\u00e9calage de l'ombre quand le joueur est mort car le sprite est plus large
        int ombre_decalage = 0;
        if (image.animation == ANIMATION_TOMATE_MORT && image.index_image > 6)
        {
            ombre_decalage = 1;
        }

        // affichage de l'ombre du joueur
        ecran.fill(color(0, 0, 0, 30));
        ecran.noStroke();
        ecran.ellipse(position.x + image.largeur / 2 - ombre_decalage, position.y + image.hauteur - ombre_decalage, image.largeur - 7, image.hauteur / 2 - 5); 

        // la jauge d'endurance clignote quand le joueur est \u00e9puis\u00e9
        if (epuise)
        {
            if (temps_global % (int) (IMAGES_PAR_SECONDE / 12) == 0)
            {
                afficher_endurance = !afficher_endurance;
            }

            endurance_visible = true;
        } else
        {
            afficher_endurance = true;
        }

        afficher_barre_endurance();   

        super.afficher();
    }


    public void afficher_barre_endurance()
    {
        if (!afficher_endurance) return;

        if (endurance_visible)
        {
            opacite_endurance = min(255, opacite_endurance + 10);
        } else
        {
            opacite_endurance = max(0, opacite_endurance - 10);
        }

        ecran.fill(color(100, 100, 100, opacite_endurance));
        ecran.rect(position.x + image.largeur * (endurance_affichee / ENDURENCE_MAX), 
                   position.y - 5, 
                   image.largeur - image.largeur * (endurance_affichee / ENDURENCE_MAX), 
                   3
                  );

        ecran.fill(color(100, 100, 255, opacite_endurance));
        ecran.rect(position.x, 
                   position.y - 5, 
                   image.largeur * (endurance_affichee / ENDURENCE_MAX),
                   3
                  );
    }


    public void perdu()
    {
        trembler(80, 0.2f, true);
        perdu = true;
        vitesse = new Vecteur(0, 0);
        image = new Image(IMAGE_TOMATE_MORT, 12, 0.6f, ANIMATION_TOMATE_MORT, false);
        son_sprouitch.trigger();
        son_game_over.trigger();
    }
}

class FantomeJoueur extends Entite
{
    FantomeJoueur(Vecteur pos, Image img, boolean mx)
    {
        super(pos, img);
        vitesse = new Vecteur(0, 0);
        image.miroir_x = mx;
    }

    public void mettre_a_jour()
    {
        image.opacite(image.opacite - 20);

        if (image.opacite < 0) detruire();
    }

    public void afficher()
    {
        if (!(position.x < 0 || position.x > 218 - image.largeur / 2 || position.y > HAUTEUR_ECRAN - image.hauteur - 10 || position.y < 37))
        {
            super.afficher();
        }
    }
}
/* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
 *   Furious Tomato - Par Benjamin Strabach, Valentin Galerne et Simon Rozec   *
 *                                                                             *
 *                     ~ Gestion de l'\u00e9cran du menu du jeu ~                   *
 * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * */

/*
	Id\u00e9es:
 		- Bouts de tomate qui sont \u00e9ject\u00e9s lors du choc
 		- Couverts aussi \u00e9ject\u00e9s lors du choc
 */

// Boutons du menu
boolean menu_init = false;
boolean selection_active;

MenuPrincipal menu;
Image imageCurseur;

boolean demande_menu;
boolean demande_quitter;
boolean demande_credits;
boolean demande_jeu;


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
//float amplitude_choc_couperet;
boolean couperet_tombe;


// Animation de l'explosion de la tomate
Image explosion_tomate;


public void initialiser_menu()
{
  menu =  new MenuPrincipal();
  selection_active = false;

  imageCurseur = new Image(IMAGE_CURSEUR);
  image_menu = new Image(IMAGE_MENU);

  demande_quitter = false;
  demande_credits = false;
  demande_jeu = false;

  tomate = new Image(IMAGE_TOMATE, 20, 0.2f, ANIMATION_TOMATE_PROFIL_FACE, true);
  couperet = new Image(IMAGE_COUPERET);
  explosion_tomate = new Image(IMAGE_EXPLOSION_TOMATE, 4, 1, ANIMATION_EXPLOSION_TOMATE, false);

  tomate_morte = false;
  tomate_x = TOMATE_X_DEBUT;

  couperet_x = 42;
  couperet_y = COUPERET_Y_DEBUT;
  couperet_angle = couperet_angle_debut;
  
  //amplitude_choc_couperet = AMPLITUDE_CHOC_COUPERET;
	couperet_tombe = false;
  
  temps_menu = 0;
  
  musique_menu.pause();
  musique_menu.rewind();
}


public void mettre_a_jour_menu()
{
  if (!touches[ENTER])
  {
    selection_active = true;
  }

  if (touche_relachee)
  {
    menu.k = false;
  }

  temps_menu++;

  menu.update();
}


public void dessiner_menu()
{
  //if (amplitude_choc_couperet < AMPLITUDE_CHOC_COUPERET) ecran.translate(random(-amplitude_choc_couperet, amplitude_choc_couperet), random(-amplitude_choc_couperet, amplitude_choc_couperet));

  image_menu.afficher(0, 0);

  menu.bjouer.afficher();
  menu.bcredits.afficher();
  menu.bquitter.afficher();

  dessiner_tomate();
  dessiner_couperet();
  
  ecran.fill(0);
  ecran.textAlign(CENTER, BOTTOM);
  ecran.text(VERSION, 4 + textWidth(VERSION) / 2, HAUTEUR_ECRAN - 2);
}


public void dessiner_couperet()
{
  ecran.pushMatrix();

  if (couperet_y < COUPERET_Y_FIN)
  {
    couperet_y = COUPERET_Y_DEBUT + temps_menu * (COUPERET_Y_FIN - COUPERET_Y_DEBUT) / (IMAGES_PAR_SECONDE * DUREE_ANIMATION_COUPERET);
    couperet_angle = couperet_angle_debut + temps_menu * (couperet_angle_fin - couperet_angle_debut) / (IMAGES_PAR_SECONDE * DUREE_ANIMATION_COUPERET);
  }
  else
  {
    tomate_morte = true;
	
	if(!couperet_tombe) // le couperet vient de toucher la table
	{
    	couperet_tombe = true;
    	trembler(AMPLITUDE_CHOC_COUPERET, 2, true);
    	son_sprouitch.trigger();
    	musique_menu.loop();
	}

    //amplitude_choc_couperet /= REDUCTION_CHOC_COUPERET;
/*
    if (amplitude_choc_couperet < 0.1)
    {
      amplitude_choc_couperet = 0;
    }
*/
    explosion_tomate.afficher(0, 47);
    explosion_tomate.mettre_a_jour();
  }

  ecran.translate(couperet_x, couperet_y);
  ecran.rotate(couperet_angle);
  couperet.afficher(-40, -20);

  ecran.popMatrix();
}


public void dessiner_tomate()
{
  if (!tomate_morte)
  {
    tomate_x = TOMATE_X_DEBUT + temps_menu * (TOMATE_X_FIN - TOMATE_X_DEBUT) / (IMAGES_PAR_SECONDE  * DUREE_ANIMATION_TOMATE);

    tomate.afficher(tomate_x, 74);
    tomate.mettre_a_jour();
  }
}


public void terminer_menu()
{
  menu_init = false;
}


class MenuPrincipal
{ 
  boolean k = false;

  Bouton bjouer = new Bouton(224, 91, "Jouer", true, IMAGE_BOUTON_JOUER);
  Bouton bcredits = new Bouton(224, 119, "Cr\u00e9dits", false, IMAGE_BOUTON_CREDITS);
  Bouton bquitter = new Bouton(224, 147, "Quitter", false, IMAGE_BOUTON_QUITTER);

  public void update()
  {
    if (keyPressed == true && selection_active) 
    {
      if (bjouer.select == true && k == false) // Bouton JOUER s\u00e9lectionn\u00e9
      {
        if (touches[UP] == true)
        {
          bjouer.select = false;
          bquitter.select = true;
          son_changer_bouton.trigger();
        } else if (touches[DOWN] == true)
        {
          bjouer.select = false;
          bcredits.select = true;
          son_changer_bouton.trigger();
        } else if (touches[ENTER] == true)
        {
          musique_menu.pause();
          musique_menu.rewind();
          son_bouton_valider.trigger();
          demande_jeu = true;
          transition.lancer();
        }
      } else if (bcredits.select == true && k == false) // Bouton CREDITS s\u00e9lectionn\u00e9
      {
        if (touches[UP] == true)
        {
          bcredits.select = false;
          bjouer.select = true;
          son_changer_bouton.trigger();
        } else if (touches[DOWN] == true)
        {
          bcredits.select = false;
          bquitter.select = true;
          son_changer_bouton.trigger();
        } else if (touches[ENTER] == true)
        {
          son_bouton_valider.trigger();
          demande_credits = true;
          transition.lancer();
        }
      } else if (bquitter.select == true && k == false) // Bouton QUITTER s\u00e9lectionn\u00e9
      {
        if (touches[UP] == true)
        {
          bquitter.select = false;
          bcredits.select = true;
          son_changer_bouton.trigger();
        } else if (touches[DOWN] == true)
        {
          bquitter.select = false;
          bjouer.select = true;
          son_changer_bouton.trigger();
        } else if (touches[ENTER] == true)
        {
          demande_quitter = true;
          transition.lancer();
        }
      }

      k = true;
    }

    if (transition.demi_transition_passee())
    {
      if (demande_quitter) 
      {
        demande_quitter = false;
        exit();
      } else if (demande_credits)
      {
        demande_credits = false;
        terminer_menu();
        scene = SCENES[CREDITS];
      } else if (demande_jeu)
      {
        demande_jeu = false;
        terminer_menu();
        scene = SCENES[JEU];
      }
    }
  }
}


class Bouton
{
  float posx, posy;
  int hauteur;
  String type;
  boolean select;
  Image imageBouton;


  Bouton(int posx, int posy, String type, boolean select, String imageBouton)
  {
    this.posx = posx;
    this.posy = posy;
    this.type = type;
    this.select = select;
    this.imageBouton = new Image(imageBouton);
    hauteur = this.imageBouton.hauteur;
  }


  public void afficher()
  {
    if (select == true)
    {
      imageCurseur.afficher(posx + 3, posy);        //Dessiner curseur
      imageBouton.afficher(posx + 20, posy);      //Dessiner bouton d\u00e9cal\u00e9
    } else
    {
      imageBouton.afficher(posx, posy);    //Dessiner bouton
    }
  }
}
/* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
 *   Furious Tomato - Par Benjamin Strabach, Valentin Galerne et Simon Rozec   *
 *                                                                             *
 *                   ~ Fichier de description des particule ~                  *
 * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * */
 
class Particule extends Entite
{
    float temps_vie;
    int couleur;
    int rayon;
    
	Particule(Vecteur position, Vecteur vitesse, Vecteur acceleration, int c, float temps_vie, int rayon)
    {
        super(position, new Image(createImage(1, 1, RGB)));
        couleur = c;
        this.temps_vie = temps_vie * IMAGES_PAR_SECONDE;
        this.rayon = rayon;
        
        this.vitesse = vitesse;
        this.acceleration = acceleration;
    }
    
    public void mettre_a_jour()
    {
        
        
        this.position.ajouter(vitesse);
        this.vitesse.multiplier(acceleration);

     	if(temps_vie-- <= 0)
        {
            detruire();   
        }
    }
    
    public void afficher()
    {
        //g.noStroke();
    	ecran.fill(couleur);
    	ecran.ellipse(position.x, position.y, rayon, rayon);
    
    	if(afficher_collision)
        {
        	ecran.fill(color(255, 100, 100, 160));
            ecran.ellipse(position.x + decalage_collision.x , position.y + decalage_collision.y, rayon_collision, rayon_collision);
        }
    }
}


/* Particule utilis\u00e9e quand le joueur est \u00e9puis\u00e9 */
class GoutteEau extends Particule
{
    GoutteEau(Vecteur pos)
    {
        super(pos, new Vecteur(random(-1.5f, 1.5f), random(-1.5f, -2)), new Vecteur(0, random(0.1f, 0.5f)), color(100, 100, 255), random(0.1f, 0.3f), 2);
    }
    
    public void mettre_a_jour()
    {
        this.position.ajouter(vitesse);
        this.vitesse.ajouter(acceleration);

        if(temps_vie-- <= 0)
        {
            detruire();
        }
    }
}


class Etincelle extends Particule
{
    boolean eteinte = false;
    
    Etincelle(Vecteur pos, int col, float vie)
    {
        super(pos, new Vecteur(0, 0), new Vecteur(random(0.65f, 0.8f), 0), col, vie + random(1), (int) random(1, 3));
        vitesse.modifierAL(random(TWO_PI), 7);
    }
    
    public void mettre_a_jour()
    {
        this.position.ajouter(vitesse);
        this.vitesse.multiplier(acceleration.x);
		
		acceleration.x += 0.04f;
		if(acceleration.x >= 1) acceleration.x = 1;

        if(temps_vie-- <= 0)
        {
            eteinte = true;
        }
    }
}

class FeuArtifice
{
    final int[] couleurs = {0xffe74c3c, 0xffe67e22, 0xffffc40f, 0xff2ecc71, 0xff1abc9c, 0xff3498db, 0xff9b59b6};
    
    ArrayList<Etincelle> ets;
    
    Vecteur pos;
    
	int nbParts;
	
 	FeuArtifice(Vecteur pos, float taille, int nbParts)
 	{
    	int cindex = (int) random(7);
    	
    	this.nbParts = nbParts;
    
    	ets = new ArrayList<Etincelle>();
    	for(int i = 0; i < nbParts; i++)
    	{
        	int ind = cindex + (int) random(0, 2);
        	if(ind > 6) ind = 0;
        
        	ets.add(new Etincelle(pos.copie(), couleurs[ind], taille));
        	
    	}
 	}
 
 	public void afficher()
	{
    	for(Etincelle e : ets)
    	{
        	e.mettre_a_jour();
        	if(!e.eteinte) e.afficher();
        }
	}
}
/* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
 *   Furious Tomato - Par Benjamin Strabach, Valentin Galerne et Simon Rozec   *
 *                                                                             *
 *                ~ Fichier de stockage des patterns de couteaux ~             *
 * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *  */

/*

 Chaque ligne est un couteau
 
 ordre des valeurs :
 
 - d\u00e9lais avant lancement
 - position x
 - position y
 - cible x
 - cible y
 - acceleration x
 - acceleration y
 - vitesse
 
 */


final float[][] PATTERN_TEST = 
    {
    {0, 0, -1, 0, 0, 0.05f, 0, 3}, 
    {8, 1, -1, 1, 0, 0.05f, 0, 3}, 
    {16, 2, -1, 2, 0, 0.05f, 0, 3}, 
    {24, 3, -1, 3, 0, 0.05f, 0, 3}, 
    {32, 4, -1, 4, 0, 0.05f, 0, 3}, 
    {40, 5, -1, 5, 0, 0.05f, 0, 3}, 
    {48, 6, -1, 6, 0, 0.05f, 0, 3}, 

    {120, -1, 0, 0, 0, 0, 0, 4}, 
    {130, -1, 1, 0, 1, 0, 0, 4}, 
    {140, -1, 2, 0, 2, 0, 0, 4}, 
    {150, -1, 3, 0, 3, 0, 0, 4}, 
};


final float[][] PATTERN_CROIX_DROITE = 
    {
    {0, -1, 0, 0, 0, 0, 0, 1.6f}, 
    {0, 8, 1, 7, 1, 0, 0, 1.6f}, 
    {0, -1, 2, 0, 2, 0, 0, 1.6f}, 
    {0, 8, 3, 7, 3, 0, 0, 1.6f}, 
};



final float[][] PATTERN_EN_COURS =
    {  
    {0, 0, -1, 6, 4, 0, 0, 4}, 
    {10, 1, -1, 5, 4, 0, 0, 4}, 
    {20, 2, -1, 4, 4, 0, 0, 4}, 
    {30, 3, -1, 3, 4, 0, 0, 4}, 
    {40, 4, -1, 2, 4, 0, 0, 4}, 
    {50, 5, -1, 1, 4, 0, 0, 4}, 
    {60, 6, -1, 0, 4, 0, 0, 4}, 
    {80, 6, 4, 0, -1, 0, 0, 4}, 
    {90, 5, 4, 1, -1, 0, 0, 4}, 
    {100, 4, 4, 2, -1, 0, 0, 4}, 
    {110, 3, 4, 3, -1, 0, 0, 4}, 
    {120, 2, 4, 4, -1, 0, 0, 4}, 
    {130, 1, 4, 5, -1, 0, 0, 4}, 
    {140, 0, 4, 6, -1, 0, 0, 4}, 
};




final float[][] PATTERN_3_COUTEAUX_DESCENTE =
    {
    {0, 0, -1, 0, 0, 0, 0, 2}, 
    {0, 3, -1, 3, 0, 0, 0, 2}, 
    {0, 6, -1, 6, 0, 0, 0, 2}, 
};

final float[][] PATTERN_3_COUTEAUX_MONTEE =
    {
    {0, 0, 4, 0, 3, 0, 0, 2}, 
    {0, 3, 4, 3, 3, 0, 0, 2}, 
    {0, 6, 4, 6, 3, 0, 0, 2}, 
};

final float[][] PATTERN_3_COUTEAUX_DROITE =
    {
    {0, -1, 0, 0, 0, 0, 0, 2}, 
    {0, -1, 1.5f, 0, 1.5f, 0, 0, 2}, 
    {0, -1, 3, 0, 3, 0, 0, 2}, 
};

final float[][] PATTERN_3_COUTEAUX_GAUCHE =
    {
    {0, 7, 0, 6, 0, 0, 0, 2}, 
    {0, 7, 1.5f, 6, 1.5f, 0, 0, 2}, 
    {0, 7, 3, 6, 3, 0, 0, 2}, 
};

final float[][] PATTERN_CROIX_4_COUTEAUX =
    {
    {0, -1, -1, 7, 4, 0, 0, 2}, 
    {0, 7, -1, -1, 4, 0, 0, 2}, 
    {0, 7, 4, -1, -1, 0, 0, 2}, 
    {0, -1, 4, 7, -1, 0, 0, 2}
};

final float[][] PATTERN_BORDS_8_COUTEAUX =
    {
    {0, 0, -1, 0, 0, 0, 0, 1.125f}, 
    {0, 6, -1, 6, 0, 0, 0, 1.125f}, 
    {0, -1, 0, 0, 0, 0, 0, 2}, 
    {0, 7, 0, 6, 0, 0, 0, 2}, 
    {0, -1, 3, 0, 3, 0, 0, 2}, 
    {0, 7, 3, 6, 3, 0, 0, 2}, 
    {0, 0, 4, 0, 3, 0, 0, 1.125f}, 
    {0, 6, 4, 6, 3, 0, 0, 1.125f}
};

final float[][] PATTERN_VAGUES_DIAGONALES_3_PHASES =
    {
    {0, 1, -1, -1, 1, 0, 0, 2}, 
    {0, 5, 4, 7, 2, 0, 0, 2}, 
    {40, -1, 3, 3, -1, 0, 0, 2}, 
    {40, 7, 0, 3, 4, 0, 0, 2}, 
    {130, 5, -1, 0, 4, 0, 0, 2}, 
    {130, 1, 4, 6, -1, 0, 0, 2}, 
};

final float[][] PATTERN_GRILLE_3_PHASES_3_COUTEAUX =
    {
    {0, 0, -1, 0, 0, 0, 0, 1.125f}, 
    {0, -1, 0, 0, 0, 0, 0, 2}, 
    {60, 3, -1, 3, 0, 0, 0, 1.125f}, 
    {60, -1, 1.5f, 0, 1.5f, 0, 0, 2}, 
    {120, 6, -1, 6, 0, 0, 0, 1.125f}, 
    {120, -1, 3, 0, 3, 0, 0, 2}, 
};


final float[][] PATTERN_CROIX_4_COUTEAUX_CENTRE_LIBRE =
    {
    {0, -1, -1, 1, 1, 0, 0, 2.4f}, 
    {0, 7, -1, 5, 1, 0, 0, 2.4f}, 
    {0, -1, 4, 1, 2, 0, 0, 2.4f}, 
    {0, 7, 4, 5, 2, 0, 0, 2.4f}, 
};

final float[][] PATTERN_4_COUTEAUX_DESCENTE =
    {
    {0, 0, -1, 0, 4, 0, 0, 2.6f}, 
    {0, 2, -1, 2, 4, 0, 0, 2.6f}, 
    {0, 4, -1, 4, 4, 0, 0, 2.6f}, 
    {0, 6, -1, 6, 4, 0, 0, 2.6f}, 
};

final float[][] PATTERN_4_COUTEAUX_MONTEE =
    {
    {0, 0, 4, 0, -1, 0, 0, 2.6f}, 
    {0, 2, 4, 2, -1, 0, 0, 2.6f}, 
    {0, 4, 4, 4, -1, 0, 0, 2.6f}, 
    {0, 6, 4, 6, -1, 0, 0, 2.6f}, 
};

final float[][] PATTERN_BOOMERANG_DESCENTE_4_3 =
    {
    {0, 0, -1, 0, 4, 0, 0, 2.4f}, 
    {0, 2, -1, 2, 4, 0, 0, 2.4f}, 
    {0, 4, -1, 4, 4, 0, 0, 2.4f}, 
    {0, 6, -1, 6, 4, 0, 0, 2.4f}, 

    {60, 1, 4, 1, 3, 0, 0, 2.4f}, 
    {60, 3, 4, 3, 3, 0, 0, 2.4f}, 
    {60, 5, 4, 5, 3, 0, 0, 2.4f}, 
};



final float[][] PATTERN_SPIRALE_BASIQUE =
    {
    {0, -1, -1, 7, 4, 0, 0, 2.4f}, 
    {20, -1, 1.5f, 7, 1.5f, 0, 0, 2}, 
    {40, -1, 4, 7, -1, 0, 0, 2.4f}, 
    {60, 1.5f, 4, 4.5f, -1, 0, 0, 1.5f}, 
    {80, 4.5f, 4, 1.5f, -1, 0, 0, 1.5f}, 
    {100, 7, 4, -1, -1, 0, 0, 2.4f}, 
    {120, 7, 1.5f, -1, 1.5f, 0, 0, 2}, 
    {140, 7, -1, -1, 4, 0, 0, 2.4f}, 
    {160, 4.5f, -1, 1.5f, 4, 0, 0, 1.5f}, 
    {180, 1.5f, -1, 4.5f, 4, 0, 0, 1.5f}, 
};

final float[][] PATTERN_HELICE_4_COUTEAUX =
    {
    {0, 2, -1, 2, 4, 0, 0, 2.4f}, 
    {0, -1, 1, 7, 1, 0, 0, 2.4f}, 
    {0, 4, 4, 4, -1, 0, 0, 2.4f}, 
    {0, 7, 2, -1, 2, 0, 0, 2.4f}, 
};

final float[][] PATTERN_MIGRATEURS_DROITE_5_COUTEAUX =
    {
    {0, -1, 1.25f, 0, 1.25f, 0, 0, 2.4f}, 
    {15, -1, 0.75f, 0, 0.75f, 0, 0, 2.4f}, 
    {15, -1, 1.75f, 0, 1.75f, 0, 0, 2.4f}, 
    {30, -1, 0.25f, 0, 0.25f, 0, 0, 2.4f}, 
    {30, -1, 2.25f, 0, 2.25f, 0, 0, 2.4f}, 
};

final float[][] PATTERN_MIGRATEURS_GAUCHE_5_COUTEAUX =
    {
    {0, 7, 1.25f, 6, 1.25f, 0, 0, 2.4f}, 
    {15, 7, 0.75f, 6, 0.75f, 0, 0, 2.4f}, 
    {15, 7, 1.75f, 6, 1.75f, 0, 0, 2.4f}, 
    {30, 7, 0.25f, 6, 0.25f, 0, 0, 2.4f}, 
    {30, 7, 2.25f, 6, 2.25f, 0, 0, 2.4f}, 
};

final float[][] PATTERN_MIGRATEURS_DEUXCOTES_5_COUTEAUX =
    {
    {0, 7, 1.25f, 6, 1.25f, 0, 0, 2.4f}, 
    {0, -1, 1.25f, 0, 1.25f, 0, 0, 2.4f}, 
    {15, 7, 0.75f, 6, 0.75f, 0, 0, 2.4f}, 
    {15, 7, 1.75f, 6, 1.75f, 0, 0, 2.4f}, 
    {15, -1, 0.75f, 0, 0.75f, 0, 0, 2.4f}, 
    {15, -1, 1.75f, 0, 1.75f, 0, 0, 2.4f}, 
    {30, 7, 0.25f, 6, 0.25f, 0, 0, 2.4f}, 
    {30, 7, 2.25f, 6, 2.25f, 0, 0, 2.4f}, 
    {30, -1, 0.25f, 0, 0.25f, 0, 0, 2.4f}, 
    {30, -1, 2.25f, 0, 2.25f, 0, 0, 2.4f}, 
};

final float[][] PATTERN_DOUBLE_REBONDS =
    {
    {0, -1, -1, 1, 4, 0, 0, 2.8f}, 
    {0, 7, 4, 5, -1, 0, 0, 2.8f}, 
    {55, 1, 4, 3, -1, 0, 0, 2.8f}, 
    {55, 5, -1, 3, 4, 0, 0, 2.8f}, 
    {110, 3, -1, 5, 4, 0, 0, 2.8f}, 
    {110, 3, 4, 1, -1, 0, 0, 2.8f}, 
    {165, 5, 4, 7, -1, 0, 0, 2.8f}, 
    {165, 1, -1, -1, 4, 0, 0, 2.8f}, 
};

final float[][] PATTERN_DELUGE_LAMES_HAUT_BASIQUE =
    {
    {0, -1, 2, 2, -1, 0, 0, 3}, 
    {30, 6, -1, 1, 4, 0, 0, 3}, 
    {60, -1, 4, 4, -1, 0, 0, 3}, 
    {60, 4, 4, -1, -1, 0, 0, 3}, 
    {60, 4, -1, -1, 4, 0, 0, 3}, 
    {90, 1, 4, 6, -1, 0, 0, 3}, 
    {120, -1, 2, 2, -1, 0, 0, 3}, 
};

final float[][] PATTERN_DELUGE_LAMES_BAS_BASIQUE =
    {
    {0, 7, 1, 4, 4, 0, 0, 3}, 
    {30, 0, 4, 5, -1, 0, 0, 3}, 
    {60, 7, -1, 2, 4, 0, 0, 3}, 
    {60, 2, -1, 7, 4, 0, 0, 3}, 
    {60, 2, 4, 7, -1, 0, 0, 3}, 
    {90, 5, -1, 0, 4, 0, 0, 3}, 
    {120, 7, 1, 4, 4, 0, 0, 3}, 
};



final float[][] PATTERN_ROUTE_DEUX_SENS =
    {
    {0, -1, 0, 7, 0, 0, 0, 1.7f}, 
    {0, -1, 1, 7, 1, 0, 0, 1.7f}, 
    {0, 7, 2, -1, 2, 0, 0, 1.7f}, 
    {0, 7, 3, -1, 3, 0, 0, 1.7f}, 
    {70, -1, 0, 7, 0, 0, 0, 1.7f}, 
    {70, -1, 1, 7, 1, 0, 0, 1.7f}, 
    {70, 7, 2, -1, 2, 0, 0, 1.7f}, 
    {70, 7, 3, -1, 3, 0, 0, 1.7f}, 
    {140, -1, 0, 7, 0, 0, 0, 1.7f}, 
    {140, -1, 1, 7, 1, 0, 0, 1.7f}, 
    {140, 7, 2, -1, 2, 0, 0, 1.7f}, 
    {140, 7, 3, -1, 3, 0, 0, 1.7f}, 
};

final float[][] PATTERN_ROUTE_DEUX_SENS_INVERSE =
    {  
    {0, 7, 0, -1, 0, 0, 0, 1.7f}, 
    {0, 7, 1, -1, 1, 0, 0, 1.7f}, 
    {0, -1, 2, 7, 2, 0, 0, 1.7f}, 
    {0, -1, 3, 7, 3, 0, 0, 1.7f}, 
    {70, 7, 0, -1, 0, 0, 0, 1.7f}, 
    {70, 7, 1, -1, 1, 0, 0, 1.7f}, 
    {70, -1, 2, 7, 2, 0, 0, 1.7f}, 
    {70, -1, 3, 7, 3, 0, 0, 1.7f}, 
    {140, 7, 0, -1, 0, 0, 0, 1.7f}, 
    {140, 7, 1, -1, 1, 0, 0, 1.7f}, 
    {140, -1, 2, 7, 2, 0, 0, 1.7f}, 
    {140, -1, 3, 7, 3, 0, 0, 1.7f}, 
};

final float[][] PATTERN_MURS_DEUX_COTES =
    {  
    {0, -1, 0, 7, 0, 0, 0, 1.7f}, 
    {0, -1, 1, 7, 1, 0, 0, 1.7f}, 
    {0, 7, 2, -1, 2, 0, 0, 1.7f}, 
    {0, 7, 3, -1, 3, 0, 0, 1.7f}, 
    {0, 7, 0, -1, 0, 0, 0, 1.7f}, 
    {0, 7, 1, -1, 1, 0, 0, 1.7f}, 
    {0, -1, 2, 7, 2, 0, 0, 1.7f}, 
    {0, -1, 3, 7, 3, 0, 0, 1.7f}, 
};

final float[][] PATTERN_CASCADE_COUTEAUX_SEPARATION =
    {  
    {0, 3, -1, 3, 4, 0, 0, 1.7f}, 
    {20, 3, -1, 3, 4, 0, 0, 1.7f}, 
    {40, 3, -1, 3, 4, 0, 0, 1.7f}, 
    {60, 3, -1, 3, 4, 0, 0, 1.7f}, 
    {60, 0, -1, 0, 4, 0, 0, 2.4f}, 
    {60, 1, -1, 1, 4, 0, 0, 2.4f}, 
    {60, 2, -1, 2, 4, 0, 0, 2.4f}, 
    {80, 3, -1, 3, 4, 0, 0, 1.7f}, 
    {100, 3, -1, 3, 4, 0, 0, 1.7f}, 
    {120, 3, -1, 3, 4, 0, 0, 1.7f}, 
    {120, 4, -1, 4, 4, 0, 0, 2.4f}, 
    {120, 5, -1, 5, 4, 0, 0, 2.4f}, 
    {120, 6, -1, 6, 4, 0, 0, 2.4f}, 
    {140, 3, -1, 3, 4, 0, 0, 1.7f}, 
    {160, 3, -1, 3, 4, 0, 0, 1.7f}, 
    {180, 3, -1, 3, 4, 0, 0, 1.7f}, 
    {180, 0, -1, 0, 4, 0, 0, 2.4f}, 
    {180, 1, -1, 1, 4, 0, 0, 2.4f}, 
    {180, 2, -1, 2, 4, 0, 0, 2.4f}, 
    {200, 3, -1, 3, 4, 0, 0, 1.7f}, 
    {220, 3, -1, 3, 4, 0, 0, 1.7f}, 
    {240, 3, -1, 3, 4, 0, 0, 1.7f}, 
    {240, 4, -1, 4, 4, 0, 0, 2.4f}, 
    {240, 5, -1, 5, 4, 0, 0, 2.4f}, 
    {240, 6, -1, 6, 4, 0, 0, 2.4f}, 
};

final float[][] PATTERN_HOLA_GAUCHE =
    {  
    {0, -1, 0, 7, 0, -0.05f, 0, 4.8f}, 
    {15, -1, 1, 7, 1, -0.05f, 0, 4.8f}, 
    {30, -1, 2, 7, 2, -0.05f, 0, 4.8f}, 
    {45, -1, 3, 7, 3, -0.05f, 0, 4.8f}, 
};

final float[][] PATTERN_HOLA_DROITE =
    {  
    {0, 7, 0, -1, 0, 0.05f, 0, 4.8f}, 
    {15, 7, 1, -1, 1, 0.05f, 0, 4.8f}, 
    {30, 7, 2, -1, 2, 0.05f, 0, 4.8f}, 
    {45, 7, 3, -1, 3, 0.05f, 0, 4.8f}, 
};

final float[][] PATTERN_DOUBLE_HOLA =
    {  
    {0, 7, 0, -1, 0, 0.05f, 0, 4.8f}, 
    {0, -1, 0, 7, 0, -0.05f, 0, 4.8f}, 
    {15, 7, 1, -1, 1, 0.05f, 0, 4.8f}, 
    {15, -1, 1, 7, 1, -0.05f, 0, 4.8f}, 
    {30, 7, 2, -1, 2, 0.05f, 0, 4.8f}, 
    {30, -1, 2, 7, 2, -0.05f, 0, 4.8f}, 
    {45, 7, 3, -1, 3, 0.05f, 0, 4.8f}, 
    {45, -1, 3, 7, 3, -0.05f, 0, 4.8f}, 
};

final float[][] PATTERN_CROIX_RAPIDE =
    {  
    {0, -1, 3, 7, -1, 0, 0.1f, 5}, 
    {0, 7, 0, -1, 4, 0, -0.1f, 5}, 
    {0, -1, 0, 7, 4, 0, -0.1f, 5}, 
    {0, 7, 3, -1, -1, 0, 0.1f, 5}, 
};

final float[][] PATTERN_DOUBLE_EVENTAIL =
    {  
    {0, 0, -1, 6, 4, 0, 0, 4}, 
    {10, 1, -1, 5, 4, 0, 0, 4}, 
    {20, 2, -1, 4, 4, 0, 0, 4}, 
    {30, 3, -1, 3, 4, 0, 0, 4}, 
    {40, 4, -1, 2, 4, 0, 0, 4}, 
    {50, 5, -1, 1, 4, 0, 0, 4}, 
    {60, 6, -1, 0, 4, 0, 0, 4}, 
    {80, 6, 4, 0, -1, 0, 0, 4}, 
    {90, 5, 4, 1, -1, 0, 0, 4}, 
    {100, 4, 4, 2, -1, 0, 0, 4}, 
    {110, 3, 4, 3, -1, 0, 0, 4}, 
    {120, 2, 4, 4, -1, 0, 0, 4}, 
    {130, 1, 4, 5, -1, 0, 0, 4}, 
    {140, 0, 4, 6, -1, 0, 0, 4}, 
};

final float[][] PATTERN_BOOMERANG_RAPIDE_4_3 =
	{
    {0, 0, -1, 0, 4, 0, 0, 2.6f}, 
    {0, 2, -1, 2, 4, 0, 0, 2.6f}, 
    {0, 4, -1, 4, 4, 0, 0, 2.6f}, 
    {0, 6, -1, 6, 4, 0, 0, 2.6f}, 

    {30, 1, 4, 1, 3, 0, 0, 2.6f}, 
    {30, 3, 4, 3, 3, 0, 0, 2.6f}, 
    {30, 5, 4, 5, 3, 0, 0, 2.6f}, 
    
    {60, 0, -1, 0, 4, 0, 0, 2.6f}, 
    {60, 2, -1, 2, 4, 0, 0, 2.6f}, 
    {60, 4, -1, 4, 4, 0, 0, 2.6f}, 
    {60, 6, -1, 6, 4, 0, 0, 2.6f}, 

    {90, 1, 4, 1, 3, 0, 0, 2.6f}, 
    {90, 3, 4, 3, 3, 0, 0, 2.6f}, 
    {90, 5, 4, 5, 3, 0, 0, 2.6f}, 
};
/* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
 *   Furious Tomato - Par Benjamin Strabach, Valentin Galerne et Simon Rozec   *
 *                                                                             *
 *                    ~ Gestion de l'\u00e9cran de fin de partie ~                  *
 * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * */

boolean fin_init = false;

final float degrade_speed_ecran_mort = 255 / (IMAGES_PAR_SECONDE * 1.5f);

float texte_degrade_speed = 2;

float opacite_ecran_mort;
float opacite_texte;

float x_mort = 0, y_mort = 0;

Image img_tomate_morte;
Image derniere_image;


String ms = "MEILLEUR SCORE !";
int curseur_hola_ms;

// feu d'artifices meilleur score :
int delais_prochain_feu;
ArrayList<FeuArtifice> arts = new ArrayList<FeuArtifice>();

public void initialiser_fin()
{
    derniere_image = new Image(ecran.get());

    opacite_ecran_mort = 0;
    opacite_texte = 0;

    img_tomate_morte = new Image(IMAGE_TOMATE_MORT, 12, 0, ANIMATION_TOMATE_MORT, false);
    img_tomate_morte.index_image = 11;
    img_tomate_morte.opacite(100);

    curseur_hola_ms = 0;
    delais_prochain_feu = 0;

    test_meilleur_score();
}


public void mettre_a_jour_fin()
{
    if(musique_partie.getGain() > SON_TRES_TRES_FAIBLE) // le volume du son diminue progressivement lors de la mort du joueur jusqu'\u00e0 devenir tr\u00e8s faible
    {
        musique_partie.setGain(musique_partie.getGain() - (SON_TRES_FAIBLE - SON_TRES_TRES_FAIBLE) / IMAGES_PAR_SECONDE); // dur\u00e9e du fade -> 1 seconde
    }
    
    if (opacite_texte >= 255)
    {
        texte_degrade_speed =  - 255 / (IMAGES_PAR_SECONDE * 1);
    }

    if (opacite_texte < 0)
    {
        texte_degrade_speed =  255 / (IMAGES_PAR_SECONDE * 1);
    }

    opacite_texte += texte_degrade_speed;
    opacite_ecran_mort += degrade_speed_ecran_mort;

    if (touches[ENTER] && touche_pressee && opacite_ecran_mort >= 400)
    {
        demande_menu = true;
        
        musique_partie.pause();
        musique_partie.rewind();
        musique_partie.setGain(SON_TRES_FAIBLE);
        son_bouton_retour.trigger();

        transition.lancer();
    }

    if (transition.demi_transition_passee() && demande_menu) // si la transition arrive \u00e0 la moiti\u00e9 et qu'on demande bien un retour au menu
    {
        demande_menu = false;
        terminer_fin(); // on quitte l'\u00e9cran cr\u00e9dits
    }
}


public void dessiner_fin()
{
    derniere_image.afficher(0, 0);

    ecran.fill(0, opacite_ecran_mort);
    ecran.rect(0, 0, LARGEUR_ECRAN, HAUTEUR_ECRAN);

    img_tomate_morte.afficher(x_mort, y_mort);

    if ( opacite_ecran_mort >= 400)
    {
        ecran.textSize(24);
        ecran.fill(255, 255, 255);
        ecran.textAlign(CENTER);
        ecran.text("Vous avez perdu", LARGEUR_ECRAN/2, HAUTEUR_ECRAN/2 - 10);
        ecran.textSize(TAILLE_POLICE-1);
        ecran.text("Temps surv\u00e9cu : " + temps_partie + " secondes", LARGEUR_ECRAN/2, HAUTEUR_ECRAN/2 + 10);

        ecran.textSize(TAILLE_POLICE-1);
        ecran.fill(120, 120, 120, opacite_texte);
        ecran.text("Presser [Entrer] pour retourner au menu", LARGEUR_ECRAN/2, HAUTEUR_ECRAN/2 + 80);

        if (score_battu == true && opacite_ecran_mort >= 490) // affichage du meilleur score
        {
            if(opacite_ecran_mort <= 500 && arts.size() < 4) // si premi\u00e8re frame ou le "meilleur score" appara\u00eet, faire spawn plein de feu d'artifice
            {
            	for(int i = 0; i < 3; i++)
            	{
                	arts.add(new FeuArtifice(new Vecteur(random(LARGEUR_ECRAN), random(HAUTEUR_ECRAN)), 0.2f, (int) random(20, 100)));
                	((int) random(2) == 0 ? son_feu_artifice_1 : son_feu_artifice_2).trigger();
            	}
            }
            
            ecran.textSize(18);
            ecran.fill(255, 255, 255);

            if (temps_global % 3 == 0) curseur_hola_ms ++;
            if (curseur_hola_ms >= ms.length() + 10) curseur_hola_ms = -2;

            float char_larg = textWidth(ms) / ms.length() + 2.5f;
            for (int i = 0; i < ms.length(); i++)
            {
                int decalage = 0;
                if (i - curseur_hola_ms == 0) decalage = 8;
                else decalage = 6 / abs(i - curseur_hola_ms);

                ecran.text(ms.charAt(i), LARGEUR_ECRAN/2 - textWidth(ms) / 2 + i*char_larg - 14, HAUTEUR_ECRAN/2 + 40 - decalage);
            }
            
            
            for(FeuArtifice fa : arts)
            {
            	fa.afficher();
            }
            
            if(delais_prochain_feu <= 0)
            {
                delais_prochain_feu = (int) (random(0.2f, 2) * IMAGES_PAR_SECONDE);
                arts.add(new FeuArtifice(new Vecteur(random(LARGEUR_ECRAN), random(HAUTEUR_ECRAN)), 0.2f, (int) random(20, 100)));
                ((int) random(2) == 0 ? son_feu_artifice_1 : son_feu_artifice_2).trigger();
            }
            else
            {
            	delais_prochain_feu --;   
            }
        }
    }
}


public void terminer_fin()
{
    scene = SCENES[MENU];
    musique_partie.setGain(SON_FAIBLE);
    fin_init = false;
    score_battu = false;
    arts.clear();
}
/* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
 *   Furious Tomato - Par Benjamin Strabach, Valentin Galerne et Simon Rozec   *
 *                                                                             *
 *                    ~ Chargement de la police d'\u00e9criture ~                   *
 * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *  */

PFont police;

public void initialiser_police()
{
  police = createFont(POLICE, TAILLE_POLICE);

  ecran.beginDraw();
  ecran.textFont(police, TAILLE_POLICE);
  ecran.endDraw();
}
/* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
 *   Furious Tomato - Par Benjamin Strabach, Valentin Galerne et Simon Rozec   *
 *                                                                             *
 *                         ~ Fichier de gestion du sel ~                       *
 * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * */

ArrayList<Sel> sel = new ArrayList<Sel>(); // liste des grains de sel affich\u00e9s \u00e0 l'\u00e9cran

class Sel extends Particule
{
    float y_cible;
    boolean au_sol;

    boolean sorti;
    float y_sortie;

    Sel(Vecteur position, Vecteur vitesse, Vecteur acceleration, float y_cible, float temps_vie)
    {
        super(position, vitesse, acceleration, 0xffFFFFFF, temps_vie, 2);
        parametrer_collision(4, new Vecteur(0, 0), AFFICHER_COLLISIONS);
        this.y_cible = y_cible;
        au_sol = false;
        sorti = false;
    }

    public void mettre_a_jour()
    {
        super.mettre_a_jour();

        if (position.y >= y_cible && !au_sol)
        {
            vitesse.x = 0;
            vitesse.y = 0;

            position.y = y_cible;

            au_sol = true;
        }

        // si le joueur sort de la planche
        if ((position.x <= 4 || position.x >= LARGEUR_PLANCHE - 4 || position.y >= HAUTEUR_ECRAN - 10) && !sorti) 
        {
            sorti = true;
            y_sortie = position.y;
        }

        // destruction si en dehors de l'\u00e9cran
        if (position.x < 0 || position.x > LARGEUR_PLANCHE || position.y < HAUTEUR_BANDEAU + 2 || position.y > HAUTEUR_ECRAN ) 
        {
            detruire();
        }            

        if (sorti)
        {
            temps_vie --; // la vie diminue deux fois plus vite
            if (position.y == y_sortie && position.y > HAUTEUR_BANDEAU + 2 )
            {
                position.y += 6;
            }
        }
    }


    public void detruire()
    {
        sel.remove(this);
    }


    public boolean collision(Joueur j)
    {
        if (!au_sol)
            return false;

        if (!super.collision(j)) 
            return false;

        vitesse.modifierAL(j.vitesse.direction(), 3 * j.vit_dep);

        float acc = random(0.5f, 0.9f);
        acceleration.modifierXY(acc, acc);

        j.ralenti = true;
        
        return true;
    }
}


class Saliere extends Entite
{
    final float BORDURE_PLANCHE = 10;

    final float DUREE_SALIERE_ACTIVE = IMAGES_PAR_SECONDE * 5;

    final float DUREE_DISPARITION_MINIATURE = DUREE_SALIERE_ACTIVE * (1.0f/10.0f);
    final float DUREE_TEMPS_REACTION = DUREE_SALIERE_ACTIVE *        (2.5f/10.0f);
    final float DUREE_DESCENTE_SALIERE = DUREE_SALIERE_ACTIVE *      (0.5f/10.0f);
    final float DUREE_SEL_TOMBE = DUREE_SALIERE_ACTIVE *             (5.0f/10.0f);
    final float DUREE_MONTEE_SALIERE = DUREE_SALIERE_ACTIVE *        (0.5f/10.0f);
    final float DUREE_DESCENTE_MINIATURE = DUREE_SALIERE_ACTIVE *    (0.5f/10.0f);

    final float TEMPS_DISPARITION_MINIATURE = 0.0f;
    final float TEMPS_ATTENTE = DUREE_DISPARITION_MINIATURE;
    final float TEMPS_DESCENTE_SALIERE = TEMPS_ATTENTE + DUREE_TEMPS_REACTION;
    final float TEMPS_SEL_TOMBE = TEMPS_DESCENTE_SALIERE + DUREE_DESCENTE_SALIERE;
    final float TEMPS_MONTEE_SALIERE = TEMPS_SEL_TOMBE + DUREE_SEL_TOMBE;
    final float TEMPS_DESCENTE_MINIATURE = TEMPS_MONTEE_SALIERE + DUREE_MONTEE_SALIERE;

    final float MINIATURE_Y_MAX = 26;
    final float SALIERE_ACTIVE_Y = HAUTEUR_BANDEAU / 2;

    Image miniature;
    Vecteur position_miniature;

    boolean activee;
    int temps_activation;
    int delais_activation;

    boolean sel_pose = false; // le sel a \u00e9t\u00e9 lanc\u00e9 (pour jouer le son qu'une fois)
    boolean saliere_haute = false; // la sali\u00e8re est remont\u00e9e (pour jouer le son qu'une fois)

    Vecteur position_zone;
    Vecteur taille_zone;

    Saliere()
    {
        super(new Vecteur(-100, -100), new Image(IMAGE_SALIERE));
        image.origine(image.largeur/2, image.hauteur/3);
        activee = false;
        temps_activation = -1;

        miniature = new Image(IMAGE_SALIERE_MINI);
        position_miniature = new Vecteur(130, MINIATURE_Y_MAX);

        position_zone = new Vecteur(0, 0);
        taille_zone = new Vecteur(0, 0);

        //desactiver();
        delais_activation = (int) (IMAGES_PAR_SECONDE * TEMPS_PALIERS[0]);
    }

    public void activer(Vecteur position_zone, Vecteur taille_zone)
    {
        activee = true;
        temps_activation = temps_global;
        this.position_zone = position_zone;
        this.taille_zone = taille_zone;
    }

    public void desactiver()
    {
        activee = false;
        temps_activation = -1;
        delais_activation = (int) (IMAGES_PAR_SECONDE * DIFF_delais_sel);
    }

    public void mettre_a_jour()
    {
        if (activee)
        {
            super.mettre_a_jour();

            float pourcentage_avancement;

            float duree_active = temps_global - temps_activation;

            if (duree_active > DUREE_SALIERE_ACTIVE)
            {
                desactiver();
            } else if (duree_active > TEMPS_DESCENTE_MINIATURE)
            {
                pourcentage_avancement = (duree_active - TEMPS_DESCENTE_MINIATURE) / DUREE_DESCENTE_MINIATURE;

                position_miniature.y = - miniature.hauteur + pourcentage_avancement * (MINIATURE_Y_MAX + miniature.hauteur);
            } else if (duree_active > TEMPS_MONTEE_SALIERE)
            {
                pourcentage_avancement = (duree_active - TEMPS_MONTEE_SALIERE) / DUREE_MONTEE_SALIERE;

                position.x = position_zone.x + taille_zone.x;
                position.y = SALIERE_ACTIVE_Y - pourcentage_avancement * (SALIERE_ACTIVE_Y + image.hauteur);
            } else if (duree_active > TEMPS_SEL_TOMBE)
            {
                pourcentage_avancement = (duree_active - TEMPS_SEL_TOMBE) / DUREE_SEL_TOMBE;

                position.x = position_zone.x + fonctionDeplacementSaliere(pourcentage_avancement) * taille_zone.x;
                position.y = MINIATURE_Y_MAX + fonctionSecouerSaliere(pourcentage_avancement, 10);

                image.angle = fonctionInclinerSaliere(pourcentage_avancement, PI/8);

                if (position.y > MINIATURE_Y_MAX + 9)
                {
                    for (int g = 0; g < (DIFF_quantite_sel * 16); g++)
                    {
                        creerGrainSel();
                    }		

                    if (!sel_pose) 
                    {
                        son_sel_tombe_fin.trigger();
                        sel_pose = true;
                        saliere_haute = false;
                    }
                }

                if (position.y < MINIATURE_Y_MAX - 8)
                {
                    sel_pose = false;
                    if (!saliere_haute)
                    {
                        son_sel_tombe_debut.trigger();
                    	saliere_haute = true;
                	}
                }

                if (temps_global % ((int) max(1, DIFF_quantite_sel * 8)) == 0) creerGrainSel();
                
            } else if (duree_active > TEMPS_DESCENTE_SALIERE)
            {
                pourcentage_avancement = (duree_active - TEMPS_DESCENTE_SALIERE) / DUREE_DESCENTE_SALIERE;

                position.x = position_zone.x;
                position.y = - image.hauteur + pourcentage_avancement * (SALIERE_ACTIVE_Y + image.hauteur);
            } else if (duree_active > TEMPS_ATTENTE)
            {
                pourcentage_avancement = (duree_active - TEMPS_ATTENTE) / DUREE_TEMPS_REACTION;
            } else if (duree_active > TEMPS_DISPARITION_MINIATURE)
            {
                position.x = - 100;
                position.y = - 100;

                pourcentage_avancement = (duree_active - TEMPS_DISPARITION_MINIATURE) / DUREE_DISPARITION_MINIATURE;

                position_miniature.y = MINIATURE_Y_MAX - pourcentage_avancement * (MINIATURE_Y_MAX + miniature.hauteur);
            }
        } else
        {
            if (--delais_activation == 0) 
            {
                float largeur = random(32, 96);
                Vecteur taille = new Vecteur(largeur, DIFF_surface_sel / largeur);
                Vecteur position = new Vecteur(random(BORDURE_PLANCHE, LARGEUR_PLANCHE - taille.x - BORDURE_PLANCHE), random(HAUTEUR_BANDEAU + BORDURE_PLANCHE, HAUTEUR_ECRAN - taille.y - BORDURE_PLANCHE));    
                activer(position, taille);
            }
        }
    }

    public void afficher()
    {
        miniature.afficher(position_miniature.x, position_miniature.y);

        if (activee)
            super.afficher();
    }


    float yprev = 0;

    public void creerGrainSel()
    {
        sel.add(0, new Sel(
            new Vecteur(position.x + random(-4, 4) * 5 * sin(image.angle), 
                        position.y + 2 * (image.hauteur / 3) + random(-2, 2)), 
            new Vecteur(-sin(image.angle) * 5, 1), 
            new Vecteur(.8f, 1.4f), 
            random(position_zone.y, position_zone.y + taille_zone.y), 
            DIFF_duree_vie_sel + random(-1, 1)
            ));
    }


    public float fonctionDeplacementSaliere(float x)
    {
        return (sin(x*3*PI-HALF_PI)) / 2 + .5f;
    }

    public float fonctionSecouerSaliere(float x, float amplitude)
    {
        return sin(x*20*PI) * amplitude;
    }

    public float fonctionInclinerSaliere(float x, float amplitude)
    {
        return sin(x*10*PI) * amplitude;
    }
}
/* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
 *   Furious Tomato - Par Benjamin Strabach, Valentin Galerne et Simon Rozec   *
 *                                                                             *
 *                    ~ Fichier de gestion de la sauvegarde ~                  *
 * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * */

String meilleur_score;
String[] data;
boolean score_battu = false;

//---------------------------------------------------------------------------------------------------------------------
public void test_meilleur_score() {
    if(temps_partie <= Integer.parseInt(meilleur_score)) 
            return;
    sauver_score();
    score_battu = true;
}
//---------------------------------------------------------------------------------------------------------------------
public void charger_score() {
  data = loadStrings("score.sav");    
  if (data == null || data.length <= 0) {
    meilleur_score = "0";
  } else {
      if (data[0] == "") {
          meilleur_score = "0";
      } else {
         dechiffrer_score();
         meilleur_score = data[0]; 
      }
  }
}
//---------------------------------------------------------------------------------------------------------------------
public void sauver_score() {
     meilleur_score = str(temps_partie);
    data = new String[1];
    data[0] = meilleur_score;
    chiffrer_score();
    saveStrings("score.sav", data);
}
//---------------------------------------------------------------------------------------------------------------------
public void chiffrer_score() {
  	int longdata = data[0].length();
	int cle = PApplet.parseInt(random(16));

	String chiffrage = str(PApplet.parseChar(cle + 64));
	for(int i = 0; i < longdata; i++) {
	chiffrage += str(PApplet.parseChar(data[0].charAt(i) + 16 + cle));
	}
	data[0] = chiffrage;
	//println(data[0]);
}

public void dechiffrer_score() {
  	int longdata = data[0].length() - 1;
	int cle = data[0].charAt(0) - 64;

	String dechiffrage = "";
	for (int i = 1;  i < longdata + 1; i++) {
    dechiffrage += str(PApplet.parseChar(data[0].charAt(i) - 16 - cle));
	}
	data[0] = dechiffrage;
	//println(data[0]);
}




/* --> Fin de partie
Si le score actuel > le meilleur score
    Le meilleur score prend la valeur du score actuel
    On chiffre le meilleur score et on le stocke dans une variable
    On sauvegarde le meilleur score chiffr\u00e9 dans un fichier
/* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
 *   Furious Tomato - Par Benjamin Strabach, Valentin Galerne et Simon Rozec   *
 *                                                                             *
 *                              ~ Gestion des sons ~                           *
 * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * */

final float SON_TRES_FORT = 6;
final float SON_FORT = 0;
final float SON_MOYEN = -5;
final float SON_FAIBLE = -10;
final float SON_TRES_FAIBLE = -22;
final float SON_TRES_TRES_FAIBLE = -35;



Minim minim;

AudioSample son_changer_bouton;
AudioSample son_bouton_retour;
AudioSample son_bouton_valider;
AudioSample son_game_over;
AudioSample son_sel_tombe_debut;
AudioSample son_sel_tombe_fin;
AudioSample son_sel_pas;
AudioSample son_impulsion;
AudioSample son_sprouitch;
AudioSample son_feu_artifice_1;
AudioSample son_feu_artifice_2;
AudioSample son_intro;

AudioSample[] voix_paliers = new AudioSample[7];

AudioPlayer musique_partie;
AudioPlayer musique_menu;



public void initialiser_son()
{
    minim = new Minim(this);
	son_changer_bouton = minim.loadSample("/sons/bouton_changement.wav", 512); son_changer_bouton.setGain(SON_MOYEN);
	son_bouton_retour = minim.loadSample("/sons/bouton_retour.wav", 512); son_bouton_retour.setGain(SON_MOYEN);
	son_bouton_valider = minim.loadSample("/sons/bouton_selection.wav", 512); son_bouton_valider.setGain(SON_MOYEN);
	son_game_over = minim.loadSample("/sons/game_over.wav", 512); son_game_over.setGain(SON_MOYEN);
	son_sel_tombe_debut = minim.loadSample("/sons/sel_debut.mp3", 512); son_sel_tombe_debut.setGain(SON_FORT);
	son_sel_tombe_fin = minim.loadSample("/sons/sel_fin.mp3", 512); son_sel_tombe_fin.setGain(SON_FORT);
	son_sel_pas = minim.loadSample("/sons/sel_debut.mp3", 512); son_sel_pas.setGain(SON_FORT);
	son_impulsion = minim.loadSample("/sons/dash.mp3", 512); son_impulsion.setGain(SON_FORT);
	son_sprouitch = minim.loadSample("/sons/sprouitch.mp3", 512); son_sprouitch.setGain(SON_FORT);
	son_feu_artifice_1 = minim.loadSample("/sons/feu_artifice_1.wav", 512); son_feu_artifice_1.setGain(SON_TRES_FAIBLE);
	son_feu_artifice_2 = minim.loadSample("/sons/feu_artifice_2.wav", 512); son_feu_artifice_2.setGain(SON_TRES_FAIBLE);
	son_intro = minim.loadSample("/sons/intro.wav", 512); son_intro.setGain(SON_FAIBLE);
	
    voix_paliers[0] = minim.loadSample("/sons/salty.wav", 512); voix_paliers[0].setGain(SON_MOYEN);
	voix_paliers[1] = minim.loadSample("/sons/nervous.wav", 512); voix_paliers[1].setGain(SON_MOYEN);	
	voix_paliers[2] = minim.loadSample("/sons/angry.wav", 512); voix_paliers[2].setGain(SON_MOYEN);
	voix_paliers[3] = minim.loadSample("/sons/ireful.wav", 512); voix_paliers[3].setGain(SON_MOYEN);
	voix_paliers[4] = minim.loadSample("/sons/mad.wav", 512); voix_paliers[4].setGain(SON_MOYEN);
	voix_paliers[5] = minim.loadSample("/sons/unleashed.wav", 512); voix_paliers[5].setGain(SON_MOYEN); // SON A FAIRE
	voix_paliers[6] = minim.loadSample("/sons/furious.wav", 512); voix_paliers[6].setGain(SON_MOYEN); // SON A FAIRE

	musique_partie = minim.loadFile("/sons/ingame_theme.mp3", 512); musique_partie.setGain(SON_FAIBLE);
	musique_menu = minim.loadFile("/sons/menu_theme.mp3", 512); musique_menu.setGain(SON_FAIBLE);
}
/* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
 *   Furious Tomato - Par Benjamin Strabach, Valentin Galerne et Simon Rozec   *
 *                                                                             *
 *                        ~ Transition entre les \u00e9crans ~                      *
 * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *  */

class Transition
{
    final float duree_transition = (DUREE_TRANSITION * IMAGES_PAR_SECONDE);

    int temps_transition;
    boolean visible;	

    boolean demi_transition;
    boolean fin_transition;

    boolean peut_recommencer;

    float l;


    public void lancer()
    {
        if (!peut_recommencer)
            return;

        visible = true;
        demi_transition = false;
        fin_transition = false;
        peut_recommencer = false;
        rembobiner();
    }


    public void mettre_a_jour()
    {
        float pourcentage_transition = ( (float) temps_transition / duree_transition);

        demi_transition = temps_transition >= duree_transition / 2;
        fin_transition = temps_transition >= duree_transition;

        if (visible && !fin_transition)
        {
            if (!demi_transition)
            {
                l = f(pourcentage_transition) * LARGEUR_ECRAN;
            }
            else
            {
                l = f( 1 - pourcentage_transition) * LARGEUR_ECRAN;
            }

            temps_transition ++;
        }
        else
        {
            fin();
        }
    }


    public float f(float x)
    {
        return x * 2;
    }


    public void afficher()
    {
        if (visible)
        {
            ecran.fill(0);

            ecran.beginShape(QUADS);
            ecran.vertex(0, 0);
            ecran.vertex(0, HAUTEUR_ECRAN);
            ecran.vertex(l - 40, HAUTEUR_ECRAN);
            ecran.vertex(l + 40, 0);

            ecran.vertex(LARGEUR_ECRAN, 0);
            ecran.vertex(LARGEUR_ECRAN, HAUTEUR_ECRAN);
            ecran.vertex(LARGEUR_ECRAN - l - 40, HAUTEUR_ECRAN);
            ecran.vertex(LARGEUR_ECRAN - l + 40, 0);
            ecran.endShape();
        }
    }


    public void fin()
    {
        visible = false;
        peut_recommencer = true;
    }


    public void rembobiner()
    {
        temps_transition = 0;
    }


    public boolean finie()
    {
        return fin_transition;
    }


    public boolean demi_transition_passee()
    {
        return demi_transition;
    }
}
/* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
 *   Furious Tomato - Par Benjamin Strabach, Valentin Galerne et Simon Rozec   *
 *                                                                             *
 *                   ~ Classes et fonctions utiles au projet ~                 *
 * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *  */

class Vecteur
{
  float x, y;

  Vecteur(float x, float y)
  {
    modifierXY(x, y);
  }


  /*
		Additionne un vecteur au vecteur
   	*/
  public void ajouter(Vecteur v2)
  {
    x += v2.x;
    y += v2.y;
  }


  /*
		Multiplie le vecteur par une valeur
   	*/
  public void multiplier(float n)
  {
    x *= n;
    y *= n;
  }


  /*
        Multiplie les composantes de deux vecteurs
   */
  public void multiplier(Vecteur v)
  {
    x *= v.x;
    y *= v.y;
  }


  /*
		Modifie le vecteur en fonction de deux composantes x et y
   	*/
  public void modifierXY(float x, float y)
  {
    this.x = x;
    this.y = y;
  }


  /*
		Modifie le vecteur selon un angle et une longueur
   	*/
  public void modifierAL(float a, float l)
  {
    this.x = cos(a) * l;
    this.y = sin(a) * l;
  }


  /*
		Retourne l'angle du vecteur
   	*/
  public float direction()
  {
    return atan2(y, x);
  }


  /*
		Retourne la longueur du vecteur
   	*/
  public float longueur()
  {
    return sqrt(x * x + y * y);
  }


  /*
		Retourne la version normalis\u00e9e du vecteur
   	*/
  public Vecteur normalise()
  {
    return new Vecteur( x / longueur(), y / longueur() );
  }


  /*
		Retourne un vecteur othogonal normalis\u00e9 au vecteur actuel
   	*/
  public Vecteur orthogonal()
  {
    return new Vecteur(-y, x).normalise();
  }


  /*
		Retourne une copie du vecteur
   	*/
  public Vecteur copie()
  {
    return new Vecteur(x, y);
  }
}


/*
	Retourne l'angle en radians entre deux points
 */
public float angle_entre(float x1, float y1, float x2, float y2)
{
  return atan2(y2 - y1, x2 - x1);
}



/* Recuperation de dur\u00e9e pour debug */
long[] time = new long[128];

public void st(int id)
{
  time[id] = System.nanoTime();
}

public void ct(int id, String text)
{
  println(text + " : " + (double)(System.nanoTime() - time[id]) / 1000000);
}
    static public void main(String[] passedArgs) {
        String[] appletArgs = new String[] { "FuriousTomato" };
        if (passedArgs != null) {
          PApplet.main(concat(appletArgs, passedArgs));
        } else {
          PApplet.main(appletArgs);
        }
    }
}
