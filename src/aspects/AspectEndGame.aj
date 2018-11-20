package aspects;

import ca.uqac.gomoku.core.model.Grid;
import ca.uqac.gomoku.core.model.Spot;

import java.util.List;
import ca.uqac.gomoku.core.Player;
import javafx.scene.paint.Color;

public aspect AspectEndGame {

	// Indicateur si la partie est finie
	private static boolean colorIsChanged = false;
	private static int i = 0;

	// On cherche a avoir le moment ou l'on modifie la valeur des winningStones
	// c'est-a-dire quand un joueur met 5 pions a cote
	pointcut getWinningStones(List<Spot> spotsWin, Grid grid) : set(List<Spot> Grid.winningStones) && args(spotsWin) && target(grid);

	// Quand un joueur a effectivement mis 5 pions a cote alors on va executer le
	// code suivant
	after(List<Spot> spotsWin, Grid grid) : getWinningStones(spotsWin, grid){

		// On met une condition afin que le code ne s'execute qu'une seule fois lorsque 
		// l'on a un gagnant. Cela va nous permettre aussi d'arreter le jeu
		if (i == 1) {
			i++;
			// On cree un nouveau joueur qui va avoir le meme nom que le gagnant mais avec une
			// couleur differente. Cela permet que seule la combinaison gagnante soit de
			// couleur differente et non tous les pions du joueur gagnant
			Player playertemp = new Player(spotsWin.get(0).getOccupant().getName(), Color.GOLDENROD);
			
			spotsWin.forEach(l -> System.out.println(l.toString()));
			//On affiche la combinaison gagnante avec la couleur differente
			spotsWin.forEach(l -> grid.placeStone(l.x, l.y, playertemp));
			colorIsChanged = true;
		}
		//On ajoute 1 car lors de l'initialisation il rentre une premiere fois dans le after
		i++;
	}

	//On cherche a arreter le placement des pions quand on obtient la combinaison gagnante, c'est-a-dire quand la couleur a ete changee
	pointcut arretDuJeu(): if(colorIsChanged==true)&&execution(public void placeStone(int, int, Player));

	//On remplance l'execution de placeStone par le néant ce qui empeche donc de continuer à jouer
	void around() : arretDuJeu() {
		// On ne fait rien si la partie est terminee
	}
}
