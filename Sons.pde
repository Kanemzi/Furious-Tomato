/* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
 *   Furious Tomato - Par Benjamin Strabach, Valentin Galerne et Simon Rozec   *
 *                                                                             *
 *                              ~ Gestion des sons ~                           *
 * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * */

final float SON_FORT = 0;
final float SON_MOYEN = -5;
final float SON_FAIBLE = -10;

import ddf.minim.*;

Minim minim;

AudioSample son_changer_bouton;
AudioSample son_bouton_retour;
AudioSample son_bouton_valider;
AudioSample son_game_over;
AudioSample son_sel_tombe_debut;
AudioSample son_sel_tombe_fin;
AudioSample son_impulsion;
AudioSample son_sprouitch;

void initialiser_son()
{
    minim = new Minim(this);
	son_changer_bouton = minim.loadSample("/sons/bouton_changement.wav", 512); son_changer_bouton.setGain(SON_FAIBLE);
	son_bouton_retour = minim.loadSample("/sons/bouton_retour.wav", 512); son_bouton_retour.setGain(SON_FAIBLE);
	son_bouton_valider = minim.loadSample("/sons/bouton_selection.wav", 512); son_bouton_valider.setGain(SON_FAIBLE);
	son_game_over = minim.loadSample("/sons/game_over.wav", 512); son_game_over.setGain(SON_FAIBLE);
	son_sel_tombe_debut = minim.loadSample("/sons/sel_debut.mp3", 512); son_sel_tombe_debut.setGain(SON_MOYEN);
	son_sel_tombe_fin = minim.loadSample("/sons/sel_fin.mp3", 512); son_sel_tombe_fin.setGain(SON_MOYEN);
	son_impulsion = minim.loadSample("/sons/dash.mp3", 512); son_impulsion.setGain(SON_FORT);
	son_sprouitch = minim.loadSample("/sons/sprouitch.mp3", 512); son_sprouitch.setGain(SON_FORT);
}