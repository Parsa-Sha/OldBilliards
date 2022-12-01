boolean velcel = true; // Forgot what this does, update this if you remember.
int firstContact = 16; // Checks which ball is currently
boolean turn; // False is first player, true is second player.
boolean solidStripe; // True is first player solid, second player stripe. False is reverse.
boolean[] allBallsBut8 = new boolean[2]; // True checks if player has all balls in except 8, index 0 = player 1
boolean anotherTurn; // Check if any of the player's balls have been pocketed.
boolean teamDecided = false; // Checks if the first ball has been pocketed
void game() {
  background(200);
  image(table, width/2-table.width/2, height-240-table.height/2);

  world.step();
  world.draw();
  calmVel();

  /*
  rect(85, 95, 370, 10); // Testing locations of all walls and holes
  rect(505, 95, 370, 10);
  rect(85, 495, 370, 10);
  rect(505, 495, 370, 10);
  rect(40, 135, 10, 325);
  rect(910, 135, 10, 325);

  noStroke();
  circle(45, 97, 28*2);
  circle(45, 503, 28*2);
  circle(915, 97, 28*2);
  circle(915, 503, 28*2);
  circle(480, 78, 28*2);
  circle(480, 521, 28*2);
  */

  for (int i = 1; i < myBalls.length; i++) {
    if (myBalls[i] != null) {
      FBody b1 = world.getBody(myBalls[i].pos.x, myBalls[i].pos.y);
      if (pb.isTouchingBody(b1)) {
        firstContact = i;
        break;
      }
    }
  }

  int gameWon = 0;
  for (int i = 0; i < myBalls.length; i++) {
    Ball b = myBalls[i];
    if ( b != null &&
      (dist(b.getX(), b.getY(), 45, 97) < 28 ||
      dist(b.getX(), b.getY(), 45, 503) < 28 ||
      dist(b.getX(), b.getY(), 915, 97) < 28 ||
      dist(b.getX(), b.getY(), 915, 503) < 28 ||
      dist(b.getX(), b.getY(), 480, 78) < 28 ||
      dist(b.getX(), b.getY(), 480, 521) < 28)
      ) {
      if (i == 0 || (i == 8 && !allBallsBut8[int(turn)])) mode = GAMEOVER;
      if (i == 8 && allBallsBut8[int(turn)]) mode = GAMEWON;

      if (teamDecided) { // If teams have already been decided
        if (solidStripe) {
          if (
            turn && i > 0 && i < 8 ||
            !turn && i > 8 && i < 16
            ) anotherTurn = true;
        } else {
          if (
            !turn && i > 0 && i < 8 ||
            turn && i > 8 && i < 16
            ) anotherTurn = true;
        }
      } else { // If teams have not been decided, set based on teams
        if (
          turn && i > 0 && i < 8 ||
          !turn && i > 8 && i < 16
          ) {
          teamDecided = true;
          solidStripe = true;
        }
        if (
          !turn && i > 0 && i < 8 ||
          turn && i > 8 && i < 16
          ) {
          teamDecided = true;
          solidStripe = false;
        }
      }

      world.remove(b);
      myBalls[i] = null;
    }
    gameWon += i;
  }

  if (gameWon == 0 || keyPressed && key=='5') mode = GAMEWON;
  if (keyPressed && key == '6') mode = GAMEOVER;

  switch(gameState) { // Potential for V4 with proper game rules, two player, and proper velocity input
  case PLAYERBEGIN:
    playerBegin();
    break;
  case PLAYERPLACE:
    playerPlace();
    break;
  case PLAYERSHOOT:
    playerShoot();
    break;
  default:
    println("GAMESTATE ERROR. ERROR = " + gameState);
  }
}
