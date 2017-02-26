/* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
 *   Furious Tomato - Par Benjamin Strabach, Valentin Galerne et Simon Rozec   *
 *                                                                             *
 *                ~ Fichier de stockage des patterns de couteaux ~             *
 * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * */
 
/*

Chaque ligne est un couteau

ordre des valeurs :

- délais avant lancement
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
	{0, 0, -1, 0, 0, 0.05, 0, 3},
	{8, 1, -1, 1, 0, 0.05, 0, 3},
	{16, 2, -1, 2, 0, 0.05, 0, 3},
	{24, 3, -1, 3, 0, 0.05, 0, 3},
	{32, 4, -1, 4, 0, 0.05, 0, 3},
	{40, 5, -1, 5, 0, 0.05, 0, 3},
	{48, 6, -1, 6, 0, 0.05, 0, 3},

	{120, -1, 0, 0, 0, 0, 0, 4},
    {130, -1, 1, 0, 1, 0, 0, 4},
    {140, -1, 2, 0, 2, 0, 0, 4},
    {150, -1, 3, 0, 3, 0, 0, 4},
};


final float[][] PATTERN_CROIX_DROITE = 
{
    {0, -1, 0,  0, 0,   0, 0, 1.6},
    {0, 8, 1,   7, 1,   0, 0, 1.6},
    {0, -1, 2,  0, 2,   0, 0, 1.6},
    {0, 8, 3,   7, 3,   0, 0, 1.6},
    /*{0, 2, -1,  2, 0,   0, 0, 3},
    {0, 4, 4,   4, 3,   0, 0, 3},*/
};


final float[][] PATTERN_EN_COURS =
{
    {0, 0, -1, 0, 0, 0, 0, 1.125},
    {0, -1, 0, 0, 0, 0, 0, 2},
    
    {60, 3, -1, 3, 0, 0, 0, 1.125},
    {60, -1, 1.5, 0, 1.5, 0, 0, 2},
    

	{120, 6, -1, 6, 0, 0, 0, 1.125},
    {120, -1, 3, 0, 3, 0, 0, 2},  
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
    {0, -1, 1.5, 0, 1.5, 0, 0, 2},
    {0, -1, 3, 0, 3, 0, 0, 2},
};

final float[][] PATTERN_3_COUTEAUX_GAUCHE =
{
    {0, 7, 0, 6, 0, 0, 0, 2},
    {0, 7, 1.5, 6, 1.5, 0, 0, 2},
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
    {0, 0, -1, 0, 0, 0, 0, 1.125},
    {0, 6, -1, 6, 0, 0, 0, 1.125},
    {0, -1, 0, 0, 0, 0, 0, 2},
    {0, 7, 0, 6, 0, 0, 0, 2},
    {0, -1, 3, 0, 3, 0, 0, 2},
    {0, 7, 3, 6, 3, 0, 0, 2},
    {0, 0, 4, 0, 3, 0, 0, 1.125},
    {0, 6, 4, 6, 3, 0, 0, 1.125}
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
    {0, 0, -1, 0, 0, 0, 0, 1.125},
    {0, -1, 0, 0, 0, 0, 0, 2},
    {60, 3, -1, 3, 0, 0, 0, 1.125},
    {60, -1, 1.5, 0, 1.5, 0, 0, 2},
    {120, 6, -1, 6, 0, 0, 0, 1.125},
    {120, -1, 3, 0, 3, 0, 0, 2}, 
};