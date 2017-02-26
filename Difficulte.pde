/* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
 *   Furious Tomato - Par Benjamin Strabach, Valentin Galerne et Simon Rozec   *
 *                                                                             *
 *                ~ Fichier de gestion de la difficulté du jeu ~               *
 * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * */
 

final String[] PALIERS = {"...", "Salty", "Nervous", "Angry", "Ireful", "Mad", "Unleashed", "Furious !!!"};
final float[] TEMPS_PALIERS = {30, 60, 90, 130, 170 ,210, 270};

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

float DIFF_cout_endurence_impulsion = 100 / 4;

final float[][] STATS_PALIERS =                    // VALEURS A MODIFIER
{
    {12,    0,        2,      1.5,    0,        0,       48*48,    4,        0,        100/2},        //1- ...
    {10,    1,        2,      1.7,    0,        10,       48*48,    4,        0,        100/3},        //2- Salty
    {10,    2,        1.7,    1.7,    0,        10,       52*52,    5,        0.5,        100/4},        //3- Nervous
    {8,     2,        1.4,    2,      0,        8,        52*52,    5,        0.5,        100/5},        //4- Angry
    {8,     2,        1.4,    2.3,    1,        8,        56*56,    6,        0.5,        100/6},        //5- Ireful
    {6,     2,        1,      2.3,    1,        6,        60*60,    7,        1,        100/7},        //6- Mad
    {6,     2,        1,      2.5,    1,        6,        60*60,    7,        1,        100/8},        //7- Unleashed
    {4,     2,        0.6,    2.5,    1,        4,        64*64,    8,        1,        100/9},        //8- Furious !!!
};


void initialiser_difficulte()
{
   palier_actuel = 0;
   modifier_stats_difficulte();
}


void mettre_a_jour_difficulte()
{
    if(temps_partie >= TEMPS_PALIERS[palier_actuel]) {
        palier_actuel += 1;
        modifier_stats_difficulte();
        println(PALIERS[palier_actuel]);
    }
}

void modifier_stats_difficulte()
{
    DIFF_delais_patterns = STATS_PALIERS[palier_actuel][0];
    DIFF_niveau_patterns = int(STATS_PALIERS[palier_actuel][1]);
    DIFF_delais_couteaux = STATS_PALIERS[palier_actuel][2];
    DIFF_vitesse_couteaux = STATS_PALIERS[palier_actuel][3];
    DIFF_couteaux_derives = boolean( (int) STATS_PALIERS[palier_actuel][4]);
    DIFF_delais_sel  = STATS_PALIERS[palier_actuel][5];
    DIFF_surface_sel = STATS_PALIERS[palier_actuel][6];
    DIFF_duree_vie_sel = STATS_PALIERS[palier_actuel][7];
    DIFF_quantite_sel = STATS_PALIERS[palier_actuel][8];
    DIFF_cout_endurence_impulsion = STATS_PALIERS[palier_actuel][9];
}