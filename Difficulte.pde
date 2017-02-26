/* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
 *   Furious Tomato - Par Benjamin Strabach, Valentin Galerne et Simon Rozec   *
 *                                                                             *
 *                ~ Fichier de gestion de la difficulté du jeu ~               *
 * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * */
 

final String[] PALLIERS = {"...", "Salty", "Nervous", "Angry", "Ireful", "Mad", "Unleashed", "Furious !!!"};
final float DELAIS_ENTRE_PALLIERS = 10;

int pallier_actuel;

float DIFF_delais_patterns = 10;
int DIFF_niveau_patterns = 1;

float DIFF_delais_couteaux;
float DIFF_vitesse_couteaux;
boolean DIFF_couteaux_derives;

float DIFF_delais_sel = 10;
float DIFF_surface_sel = 64 * 48;
float DIFF_duree_vie_sel = 6;
float DIFF_quantite_sel;

float DIFF_cout_endurence_impulsion = 100 / 4;

final float[][] STATS_PALLIERS =
{
	{},
	{},
	{},
};


void initialiser_difficulte()
{
   
}


void mettre_a_jour_difficulte()
{
    
}