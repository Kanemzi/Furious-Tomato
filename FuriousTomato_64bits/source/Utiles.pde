/* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
 *   Furious Tomato - Par Benjamin Strabach, Valentin Galerne et Simon Rozec   *
 *                                                                             *
 *                   ~ Classes et fonctions utiles au projet ~                 *
 * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *  */

class Vecteur
{
  float x, y;

  Vecteur(float x, float y)
  {
    modifierXY(x, y);
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
        Multiplie les composantes de deux vecteurs
   */
  void multiplier(Vecteur v)
  {
    x *= v.x;
    y *= v.y;
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
    return atan2(y, x);
  }


  /*
		Retourne la longueur du vecteur
   	*/
  float longueur()
  {
    return sqrt(x * x + y * y);
  }


  /*
		Retourne la version normalisée du vecteur
   	*/
  Vecteur normalise()
  {
    return new Vecteur( x / longueur(), y / longueur() );
  }


  /*
		Retourne un vecteur othogonal normalisé au vecteur actuel
   	*/
  Vecteur orthogonal()
  {
    return new Vecteur(-y, x).normalise();
  }


  /*
		Retourne une copie du vecteur
   	*/
  Vecteur copie()
  {
    return new Vecteur(x, y);
  }
}


/*
	Retourne l'angle en radians entre deux points
 */
float angle_entre(float x1, float y1, float x2, float y2)
{
  return atan2(y2 - y1, x2 - x1);
}



/* Recuperation de durée pour debug */
long[] time = new long[128];

void st(int id)
{
  time[id] = System.nanoTime();
}

void ct(int id, String text)
{
  println(text + " : " + (double)(System.nanoTime() - time[id]) / 1000000);
}