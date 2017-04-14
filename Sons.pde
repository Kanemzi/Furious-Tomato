/* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
 *   Furious Tomato - Par Benjamin Strabach, Valentin Galerne et Simon Rozec   *
 *                                                                             *
 *                              ~ Gestion des sons ~                           *
 * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * */

final float SON_TRES_FORT = 6;
final float SON_FORT = 0;
final float SON_MOYEN = -5;
final float SON_FAIBLE = -10;
final float SON_TRES_FAIBLE = -22;
final float SON_TRES_TRES_FAIBLE = -35;

import ddf.minim.*;

Minim minim;

AudioSample son_changer_bouton;
AudioSample son_bouton_retour;
AudioSample son_bouton_valider;
AudioSample son_game_over;
AudioSample son_sel_tombe_debut;
AudioSample son_sel_tombe_fin;
AudioSample son_sel_pas;
AudioSample son_impulsion;
AudioSample son_sprouitch;
AudioSample son_feu_artifice_1;
AudioSample son_feu_artifice_2;
AudioSample son_intro;

AudioSample[] voix_paliers = new AudioSample[7];

AudioPlayer musique_partie;



void initialiser_son()
{
    minim = new Minim(this);
	son_changer_bouton = minim.loadSample("/sons/bouton_changement.wav", 512); son_changer_bouton.setGain(SON_TRES_FAIBLE);
	son_bouton_retour = minim.loadSample("/sons/bouton_retour.wav", 512); son_bouton_retour.setGain(SON_TRES_FAIBLE);
	son_bouton_valider = minim.loadSample("/sons/bouton_selection.wav", 512); son_bouton_valider.setGain(SON_TRES_FAIBLE);
	son_game_over = minim.loadSample("/sons/game_over.wav", 512); son_game_over.setGain(SON_MOYEN);
	son_sel_tombe_debut = minim.loadSample("/sons/sel_debut.mp3", 512); son_sel_tombe_debut.setGain(SON_FORT);
	son_sel_tombe_fin = minim.loadSample("/sons/sel_fin.mp3", 512); son_sel_tombe_fin.setGain(SON_FORT);
	son_sel_pas = minim.loadSample("/sons/sel_debut.mp3", 512); son_sel_pas.setGain(SON_FORT);
	son_impulsion = minim.loadSample("/sons/dash.mp3", 512); son_impulsion.setGain(SON_FORT);
	son_sprouitch = minim.loadSample("/sons/sprouitch.mp3", 512); son_sprouitch.setGain(SON_FORT);
	son_feu_artifice_1 = minim.loadSample("/sons/feu_artifice_1.wav", 512); son_feu_artifice_1.setGain(SON_TRES_FAIBLE);
	son_feu_artifice_2 = minim.loadSample("/sons/feu_artifice_2.wav", 512); son_feu_artifice_2.setGain(SON_TRES_FAIBLE);
	son_intro = minim.loadSample("/sons/intro.wav", 512); son_intro.setGain(SON_TRES_FAIBLE);
	
    voix_paliers[0] = minim.loadSample("/sons/salty.wav", 512); voix_paliers[0].setGain(SON_TRES_FAIBLE);
	voix_paliers[1] = minim.loadSample("/sons/nervous.wav", 512); voix_paliers[1].setGain(SON_TRES_FAIBLE);	
	voix_paliers[2] = minim.loadSample("/sons/angry.wav", 512); voix_paliers[2].setGain(SON_TRES_FAIBLE);
	voix_paliers[3] = minim.loadSample("/sons/ireful.wav", 512); voix_paliers[3].setGain(SON_TRES_FAIBLE);
	voix_paliers[4] = minim.loadSample("/sons/mad.wav", 512); voix_paliers[4].setGain(SON_TRES_FAIBLE);
	voix_paliers[5] = minim.loadSample("/sons/mad.wav", 512); voix_paliers[5].setGain(SON_TRES_FAIBLE); // SON A FAIRE
	voix_paliers[6] = minim.loadSample("/sons/mad.wav", 512); voix_paliers[6].setGain(SON_TRES_FAIBLE); // SON A FAIRE

	musique_partie = minim.loadFile("/sons/ingame_theme.mp3", 512); musique_partie.setGain(SON_TRES_FAIBLE);
}