/* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
 *   Furious Tomato - Par Benjamin Strabach, Valentin Galerne et Simon Rozec   *
 *                                                                             *
 *                          ~ Fichier de configuration ~                       *
 * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * */

/* Informations globales */

final int LARGEUR_ECRAN = 320;
final int HAUTEUR_ECRAN = 180;
final int ECHELLE = 3;
final int IMAGES_PAR_SECONDE = 60;


/* Images */

final String IMAGE_LOGO_INTRO = "logo_isn2017.png";
final String IMAGE_CUISINIER = "animation_cuisinier.png";
final String IMAGE_TOMATE = "animation_tomate.png";
final String IMAGE_COUTEAU = "couteau.png";
final String IMAGE_SALIERE = "saliere.png";
final String IMAGE_PLANCHE = "planche.png";
final String IMAGE_INTERFACE = "interface.png";
final String IMAGE_SALIERE_MINI = "saliere_mini.png";
final String IMAGE_CHIFFRES = "chiffres.png";


final int[] ANIMATION_NON = {0};
final int[] ANIMATION_CUISINIER_NORMAL = {0, 1, 0, 2};
final int[] ANIMATION_CUISINIER_ENERVE = {3, 4};

final int[] ANIMATION_TOMATE_PROFIL = {0, 1, 2, 1, 0, 3, 4, 3};
final int[] ANIMATION_TOMATE_FACE = {10, 11, 12, 11, 10, 13, 14, 13};

//temp
final int[] ANIM_CHIFFRES = {/*0, 1, 2, 3, 4, 5, 6, 7, 8, 9, */10, 11, 12, 13, 14, 15, 16, 17, 18, 19/*, 20, 21*/};


/* CONSTANTES */
final int INTRO = 0;
final int MENU = 1;
final int CREDITS = 2;
final int JEU = 3;
final int FIN = 4;
final int QUITTER = 5;
final String[] ECRANS = {"intro", "menu", "credits", "jeu", "fin", "quitter"};