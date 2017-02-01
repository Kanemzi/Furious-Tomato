boolean credits_init = false;

Image img;

void initialiser_credits()
{
}


void mettre_a_jour_credits()
{
    if(touches[ENTER])
    {
    	terminer_credits();
	}
}


void dessiner_credits()
{
    background(#FF00FF);
}


void terminer_credits()
{
    ecran = ECRANS[MENU];
}