/* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
 *   Furious Tomato - Par Benjamin Strabach, Valentin Galerne et Simon Rozec   *
 *                                                                             *
 *                          ~ Fichier de configuration ~                       *
 * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * */

/* Informations globales */
final int LARGEUR_ECRAN = 320;
final int HAUTEUR_ECRAN = 180;
final int LARGEUR_PLANCHE = 230;
final int HAUTEUR_PLANCHE = 130;
final int HAUTEUR_BANDEAU = HAUTEUR_ECRAN - HAUTEUR_PLANCHE;
final int ECHELLE = 2;
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
final float DUREE_ANIMATION_TOMATE = 0.6;
final float DUREE_ANIMATION_COUPERET = 0.6;
final float AMPLITUDE_CHOC_COUPERET = 64;
final float REDUCTION_CHOC_COUPERET = 1.2;


/* Autres */
final boolean AFFICHER_COLLISIONS = false;
final float DUREE_TRANSITION = 0.5;

final String POLICE = "fonts/Gibberesque.ttf";
final float TAILLE_POLICE = 16;


/* Touches */
final int TOUCHE_HAUT = UP;
final int TOUCHE_BAS = DOWN;
final int TOUCHE_DROITE = RIGHT;
final int TOUCHE_GAUCHE = LEFT;
final int TOUCHE_IMPULSION = 32;
final int TOUCHE_VALIDER = ENTER;
final int TOUCHE_RETOUR = RETURN;


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