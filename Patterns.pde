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