/* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
 *   Furious Tomato - Par Benjamin Strabach, Valentin Galerne et Simon Rozec   *
 *                                                                             *
 *                   ~ Classes et fonctions utiles au projet ~                 *
 * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * */

class Vecteur
{
	float x, y;
		
	Vecteur(float x, float y)
	{
		this.x = x;
		this.y = y;
	}
	

	/*
		Additionne un vecteur au vecteur
	*/
	void ajouter(Vecteur v2)
	{
		x += v2.x;
		y += v2.y;
	}


	/*
		Multiplie le vecteur par une valeur
	*/
	void multiplier(float n)
	{
		x *= n;
		y *= n;
	}


	/*
		Modifie le vecteur en fonction de deux composantes x et y
	*/
	void modifierXY(float x, float y)
	{
    	this.x = x;
    	this.y = y;
	}


	/*
		Modifie le vecteur selon un angle et une longueur
	*/
	void modifierAL(float a, float l)
	{
    	this.x = cos(a) * l;
    	this.y = sin(a) * l;
	}


	/*
		Retourne l'angle du vecteur
	*/
	float direction()
	{
    	return atan2(x, y);
	}


	/*
		Retourne la longueur du vecteur
	*/
	float longueur()
	{
    	return sqrt(x * x + y * y);
	}
}


/*
	Retourne l'angle en radians entre deux points
*/
float angle_entre(float x1, float y1, float x2, float y2)
{
    return atan2(y2 - y1, x2 - x1);   
}