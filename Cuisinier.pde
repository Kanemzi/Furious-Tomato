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
    final float TEMPS_REACTION = 0.8;
    float duree_lancement_pattern;

    GenerateurCouteau gc;

    float duree_pat_actuel;
    float temps;

    Cuisinier()
    {
        super(new Vecteur(242, 58), new Image(IMAGE_CUISINIER, 5, 0.01, ANIMATION_CUISINIER_NORMAL, true));
        temps = 4;
        choisir_pattern();
        gc = new GenerateurCouteau();
    }

    void mettre_a_jour()
    {
        super.mettre_a_jour();

        temps--;
        if ( temps <= 0) // délais entre les attaques atteint
        {
            if (temps == 0) // première frame de l'animation d'attaque
            {
                trembler(2, DUREE_ENERVE_SUPPLEMENTAIRE, false);
                image.changerAnimation(ANIMATION_CUISINIER_ENERVE, 0.3, false, true, true);
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
                image.changerAnimation(ANIMATION_CUISINIER_NORMAL, 0.01, false, true, true);
            }
        } else
        {
            gc.mettre_a_jour();
        }
    }


    void choisir_pattern()
    {
        int i = (int) random(PATTERNS[DIFF_niveau_patterns].length);
        
        pattern = PATTERNS[DIFF_niveau_patterns][i];

        duree_pat_actuel = pattern.duree();

        duree_lancement_pattern = (TEMPS_REACTION + DUREE_ENERVE_SUPPLEMENTAIRE) * IMAGES_PAR_SECONDE + duree_pat_actuel;
    }


    void afficher()
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
    int temps; // le temps depuis le lançement du pattern
    int avancement; // le nombre de couteaux du pattern déjà lancés

    boolean en_cours; // le pattern est en train d'être lancé (mis à jour)

    Couteau[] cts;
    int[] delais;
    Vecteur decalage;

    Couteau c;

    /*
    	Crée un pattern
     
     	- Les deux tableaux doivent avoir la même taille
     	- Les délais correspondent aux moment ou les couteaux sont lancés à partir du lançement du pattern (en ticks)
     	- Les délais doivent être indiqués par ordre croissant;
     */
    Pattern(float[][] p)
    {
        delais = new int[p.length];
        cts = new Couteau[p.length];

        for (int i = 0; i < p.length; i++)
        {
            delais[i] = (int) p[i][0];
            c = new Couteau(new Vecteur(16.5 + p[i][1] * 33, HAUTEUR_BANDEAU + 16.5 + p[i][2] * 33), new Vecteur(16.5 + p[i][3] * 33, HAUTEUR_BANDEAU + 16.5 + p[i][4] * 33));
            c.modifierAcceleration(p[i][5], p[i][6]);
            c.modifierVitesse(p[i][7]);
            cts[i] = c;
        }
    }


    void initialiser(Vecteur decalage)
    {
        this.decalage = decalage;
        temps = 0;
        avancement = 0;
        en_cours = true;
    }


    void mettre_a_jour()
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


    void stopper()
    {
        en_cours = false;
    }


    void creer_couteau(Couteau c)
    {
        this.c = c;
        couteaux.add(c);
    }


    /*
    	Retourne une copie d'un objet couteau (/!\ Fonction lente à utiliser le moins souvent possible)
     */
    Couteau cloner_couteau(Couteau c)
    {
        Couteau cl = new Couteau(new Vecteur(c.position.x, c.position.y), new Vecteur(c.position_cible.x, c.position_cible.y));
        cl.modifierAcceleration(c.acceleration.x, c.acceleration.y);
        cl.modifierVitesse(c.vitesse.longueur());
        return cl;
    }


    int duree()
    {
        return delais[delais.length-1] + (int)( LARGEUR_PLANCHE / cts[cts.length-1].vitesse.longueur());
    }
}