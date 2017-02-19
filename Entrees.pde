/* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
 *   Furious Tomato - Par Benjamin Strabach, Valentin Galerne et Simon Rozec   *
 *                                                                             *
 *                   ~ Fichier de gestion des entrées clavier ~                *
 * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * */

boolean[] touches = new boolean[256];

boolean touche_pressee = false;
boolean touche_relachee = false;


void keyPressed()
{
	touches[keyCode] = true;
    touche_pressee = true;
}


void keyReleased()
{
    touches[keyCode] = false;
    touche_relachee = true;
}


void mettre_a_jour_entrees()
{
    touche_pressee = false;
    touche_relachee = false;
}

/*
void mousePressed()
{
        for(int i = 0; i < 200; i++)
        {
            entites.add(new Particule(new Vecteur(mouseX / ECHELLE, mouseY / ECHELLE),
                                      new Vecteur(random(-10, 10), random(-6, 6)),
                                      new Vecteur(random(0.1, 0.7), random(0.2, 0.8)),
                                     #C64617,
                                        random(2, 5), (int)random(2, 5)
                                    ));
        }
        for(int i = 0; i < 100; i++)
        {
            entites.add(new Particule(new Vecteur(mouseX / ECHELLE, mouseY / ECHELLE),
                                      new Vecteur(random(-20, 20), random(-6, 6)),
                                      new Vecteur(random(0.1, 0.8), random(0.2, 0.8)),
                                     #C64617,
                                        random(2, 5), (int)random(1, 4)
                                    ));
        }
}*/