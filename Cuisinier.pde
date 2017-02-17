/* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
 *   Furious Tomato - Par Benjamin Strabach, Valentin Galerne et Simon Rozec   *
 *                                                                             *
 *                      ~ Fichier de gestion du cuisinier ~                    *
 * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * */

class Cuisinier extends Entite
{
    final float DUREE_ENERVE = 2;
    
    GenerateurCouteau c;
    
    float intervalleCuisinier;
    float temps;
    
    Cuisinier()
    {
        super(new Vecteur(242, 58), new Image(IMAGE_CUISINIER, 5, 0.01, ANIMATION_CUISINIER_NORMAL, true));
        intervalleCuisinier = 10 * IMAGES_PAR_SECONDE;
        temps = intervalleCuisinier;
        c = new GenerateurCouteau();
    }
    
    void mettre_a_jour()
    {
        super.mettre_a_jour();
        c.mettre_a_jour();
        
        temps--;
        if ( temps <= 0)
        {
            if(temps == 0)
            {
            	trembler(2, DUREE_ENERVE, false);   
            }
            
            image.changerAnimation(ANIMATION_CUISINIER_ENERVE, 0.3, false, true, true);
            
            if ( temps == (- DUREE_ENERVE / 5 ) * IMAGES_PAR_SECONDE)
            {
                for ( int i = 0 ; i < 10 ; i++ )
                {
                    entites.add(new Couteau(c.genererPosition(), c.genererCible()));
                }
            }
            
            if ( temps <= - DUREE_ENERVE * IMAGES_PAR_SECONDE )
            {
                temps = intervalleCuisinier;
                image.changerAnimation(ANIMATION_CUISINIER_NORMAL, 0.01, false, true, true);
            }
        }
    }
}