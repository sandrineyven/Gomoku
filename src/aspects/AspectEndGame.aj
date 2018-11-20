package aspects;

import ca.uqac.gomoku.core.model.Grid;
import ca.uqac.gomoku.core.model.Spot;

import java.util.ArrayList;
import java.util.List;

import ca.uqac.gomoku.core.GridEventListener;
import ca.uqac.gomoku.core.Player;
import javafx.scene.paint.Color;

public aspect AspectEndGame {

	// Indicateur si la partie est finie
	private static boolean gameIsOver = false;
	private static boolean colorIsChanged = false;
	private static List<Spot> spotsWinLocal = new ArrayList<>(0);
	private static int i = 0;

	pointcut getWinningStones(List<Spot> spotsWin, Grid grid) : set(List<Spot> Grid.winningStones) && args(spotsWin) && target(grid);

	after(List<Spot> spotsWin, Grid grid) : getWinningStones(spotsWin, grid){

		if (i == 1) {
			i++;
			Player playertemp = new Player(spotsWin.get(0).getOccupant().getName(), Color.GOLDENROD);
			spotsWin.forEach(l -> System.out.println(l.toString()));
			spotsWin.forEach(l -> grid.placeStone(l.x, l.y, playertemp));
			colorIsChanged = true;
		}
		i++;

	}	

	pointcut arretDuJeu(): execution(public void placeStone(int, int, Player)) && if(colorIsChanged==true);

	void around() : arretDuJeu() {
		// On ne fait rien si la partie est terminee
	}

}