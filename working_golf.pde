/*RULES:
 
 -PRESS ANY KEY TO STOP THE MOVING PLAYER AND PRESS ANY KEY AGAIN DEPENDING ON THE LAUNCHING STRENGTH YOU WANT (BASED ON THE POWER METER) TO RELEASE THE BALL
 -10 TRIES MAXIMUM --> GAME ENDS AFTER THAT
 
 
 */


//For the Strength Meter:
int a=150;
int b=150;
int c=150;
int d=150;
int f=150;
int colour=#FF9B05 ;


//For hiding ball within the background of launch area:
int ballColour=150;

//For the Player:
float x1=0;
float x3=100;
float x2=dist(0, height, x3, height)/2;
float playerSpeed;
int movingSpeed=2;

//For Counting number of times key is pressed:
int keyCounter=0;

//For the Grass Area:
int [] green= new int [280];

//For the Ball Hole:
int [] ballHoleX =  new int [100];
int []ballHoleY= new int [100];
int m=0;


int timing=0; //For the Main timer


int arrayCounter= 0; //Counter for Multiple Balls for the Array
int timer=0;         //Timer which Starts when key is pressed or resets 

//Variables for Stroring Ball X location when Key is Presed second time
float pos1=0;
float pos2=0;
float pos3=0;
float pos4=0;
float pos5=0;
float pos6=0;
float pos7=0;
float pos8=0;
float pos9=0;
float pos10=0;

//For the Ball X and Y locations and the Individual Speeds of Golf Balls:
float [] golfBallX= {x2, 50, 50, 50, 50, 50, 50, 50, 50, 50};
float [] golfBallY= {625, 625, 625, 625, 625, 625, 625, 625, 625, 625};
float speeder[]={1, 1, 1, 1, 1, 1, 1, 1, 1, 1};


void setup() {
  size (952, 714);

  //Array for the Patchwork: 
  for (int i=0; i<green.length; i++) {
    green[i]= (int)random(80, 255);
  }

  //For Ball Holes
  for (int i=0; i<ballHoleX.length; i++) {
    ballHoleX[i]= (int)random(50, 725);
  }
  for (int j=0; j< ballHoleY.length; j++) {
    ballHoleY[j]= (int)random(50, height-height/3-50);
  }
}

void draw() {

  //GRASS AREA:
  int filler=0;  
  for (int k=0; k<(height/2+height/6); k+=50) {
    for (int j=0; j<width; j+=50) {
      noStroke();
      fill(0, green[filler], 0);
      rect(j, k, 50, 50);

      if (filler<280) {
        filler++;
      }
    }
  }


  launchArea();      //Draws the Grey Launching Area

  launchMeter();      //Draws the Outlines for the Launch Meter

  ballHole();        //Draws the Ball Hole at random places every time the program is run

  ballStrength();

  drawPlayer(70, height);    // Draws player at Height-70 and the thid corner is at height for the y value
  x1+=playerSpeed;
  x2+=playerSpeed;
  x3+=playerSpeed;

  movePlayer();              //Moves the Player Left and Right


  //FOR BALLS:
  ballPositions();            //Stores the X Value for the Second Key Preses
  golfBalls();                //Main Function responsible for multiple balls and their speeds and collisions and determining the winner

  displayScoreText();          //Displays amount of Shots Hit and amount left
}



void keyPressed () {   


  keyCounter++;
  ballColour=255;

  if (keyCounter%2>=0 ) { //STOPS THE PLAYER ON 1st KEY PRESS
    playerSpeed=0;
  }

  if (keyCounter%2==0) {    //INCREASES THE COUNTER FOR THE ARRAY ONLY ON THE SECOND KEYPRESS
    arrayCounter++;

    if (arrayCounter>10) {    //IF KEY IS PRESSED FOR THE SECOND TIME AGAIN IN ATTEMPT TO LAUNCH THE BALL AFTER 10 BALLS HAVE BEEN SHOT, THE GAME ENDS
      keyCounter=0;
      arrayCounter=0;

      noLoop();
      gameLoseText();
    }
  }



  if (keyCounter%2==1 ) {        //STARTS TIMER ON THE FIRST KEY PRESS FOR THE POWER BAR
    timer=millis();
  }
}


void drawBall (float x, float y) {
  fill (ballColour);
  ellipse (x, y, 25, 25);
}


void drawPlayer (float x, float y) {   //Moving player

  noStroke();
  fill (255, 0, 0);
  triangle(x1, height, x2, height-x, x3, y);        //Draws it at pre-given x1 which is 0, x2 is half of the distance between 0 and y and y is the float y input)
}


void launchArea() {
  
  noStroke();
  fill(150);
  rectMode(CORNER);
  rect(0, height-height/3, width, height);
}



void launchMeter() {
  
  fill (a);
  rect(1, 260, 15, 35);
  fill (b);
  rect(1, 295, 15, 35);
  fill (c);  
  rect(1, 330, 15, 35);
  fill (d);
  rect(1, 365, 15, 35);
  fill(f);
  rect(1, 400, 15, 35);
}


void ballStrength() {
  if (keyCounter%2==1 ) {                       //Starts the timer for the power bar once key is pressed for the first time
    timing=millis()-timer;

    if (timing>4500) {                            //Resets the Timer if it goes past 4.5 seconds (since full power is "after 4 seconds")
      timer=millis();
    }
  }

  int colourChange=225;

  //Incrementing and Decrementing the Power bar and the corresponding colours:
  if (keyCounter%2==1 ) {                         

    if (timing <=1000) {
      f=colour;
    } 

    if (timing>1000 && timing<2001) {
      d=colour-colourChange;
    } 

    if (timing>2000 && timing <3001) {
      c=colour-(2*colourChange);
    } 
    
    if (timing>3000 && timing <4001) {
      b=colour-(3*colourChange);
    } 

    if (timing>4000) {
      a=colour-(4*colourChange);
    }
  }

  //Resets the Bar:
  if (timing>4500 || playerSpeed>0 || playerSpeed <0) {          //If time is greater than greater than 4.5 seconds or the player is moving in either directions reset the launch bar
    resetLaunchBar();
  }
}


void ballHole() {
  fill(0);
  ellipse (ballHoleX[m], ballHoleY[m], 60, 60);              //Accesses the 0th element from the array every time the program is run which would be a random number within the given domain in setup
}


void movePlayer() {         //For moving the player

  if (x3>=width) {                     
    playerSpeed = -movingSpeed;
  } else if (x1<=0) {
    playerSpeed = movingSpeed;
  }
}



void ballPositions() {    //Storing the Golf Ball's x position into a variable each time key is pressed to stop the ball
 
  if (keyCounter==1) {
    pos1=x2;
  }

  if (keyCounter==3) {
    pos2 =x2;
  }

  if (keyCounter==5) {
    pos3=x2;
  }

  if (keyCounter==7) {
    pos4=x2;
  }

  if (keyCounter==9) {
    pos5=x2;
  }

  if (keyCounter==11) {
    pos6 =x2;
  }

  if (keyCounter==13) {
    pos7=x2;
  }

  if (keyCounter==15) {
    pos8=x2;
  }


  if (keyCounter==17) {
    pos9=x2;
  }

  if (keyCounter==19) {
    pos10=x2;
  }
}


void golfBalls() {                                  //THE MAIN FUNCTION FOR THE MULTIPLE GOLF BALLS AND THEIR LOCATIONS AND SPEEDS AND THE WIN CONDITION AND COLLISIONS


  for (int ballCount=0; ballCount<arrayCounter; ballCount++) {
    fill(ballColour);
    drawBall(golfBallX[ballCount], golfBallY[ballCount]);


    if (keyCounter%2==0) {            //STORES THE X-POSITION WHEN BALL IS STOPED 

      golfBallX[0]=pos1;
      golfBallX[1]=pos2;
      golfBallX[2]=pos3;
      golfBallX[3]=pos4;
      golfBallX[4]=pos5;
      golfBallX[5]=pos6;
      golfBallX[6]=pos7;
      golfBallX[7]=pos8;
      golfBallX[8]=pos9;
      golfBallX[9]=pos10;
    }

    //DETERMINE THE STRENGTH OF THE BALL HIT :
    if (timing<1001 ) {
      golfBallY[ballCount]-=speeder[ballCount];
      speeder[ballCount]*=0.001;
    }

    if (timing >1000 && timing <2001) {
      golfBallY[ballCount]-=4*speeder[ballCount];
      speeder[ballCount]*=0.985;
    }


    if (timing>2000 && timing <3001) {
      golfBallY[ballCount]-=6*speeder[ballCount];
      speeder[ballCount]*=0.985;
    }


    if (timing>3000 && timing <4001) {
      golfBallY[ballCount]-=8.5*speeder[ballCount];
      speeder[ballCount]*=0.985;
    }


    if (timing>4000) {
      golfBallY[ballCount]-=16*speeder[ballCount];
      speeder[ballCount]*=0.985;

    
      if (golfBallY[ballCount]<0) {
        speeder[ballCount]= -0.25;
      }
    }



    if (dist(ballHoleX[m], ballHoleY[m], golfBallX[ballCount], golfBallY[ballCount])+12.5 <=30 && speeder[ballCount]<=0.020 && speeder[ballCount]>=-0.002) {      //DETERMINING IF THE BALL IS COMPLETELY WITHIN THE HOLE

      noLoop();
      gameWinText();
    }


    if (speeder[ballCount]<0.015 && speeder[ballCount]>-0.002 && keyCounter%2==0 ) {           //MAKES THE PLAYER AUTOMATICALLY START MOVING ONCE THE BALL HAS SLOWED DOWN (AND NOT GONE INTO THE HOLE)
      playerSpeed=movingSpeed;

      if (x3>=width) { 
        movingSpeed=-2;
      } else if (x1<=0) {
        movingSpeed=2;
      }
    } else {
      playerSpeed=0;
    }


    //BALL COLLISIONS:

    for (int k=0; k<ballCount; k++) {
      if (dist(golfBallX[ballCount], golfBallY[ballCount], golfBallX[k], golfBallY[k])<=25) {    //Varible K is any other ball the current ball (i) collides with since K is inside a loop         

        speeder[k]=0.5*speeder[ballCount];
        speeder[ballCount]*=0.987;                                                     //Slows the original ball launched down because of lost energy
      }
    }
  }
}


void resetLaunchBar() {                  //Resets the colours of the launch bar by setting them all back to the background colour
  a=150;
  b=150;
  c=150;
  d=150;
  f=150;
}


void displayScoreText() {                  //Displays how many Balls are hit so far and how many tries remaining on the top right

  fill(0);
  textSize(16);
  text("Shots Hit:", 845, 50);
  text(arrayCounter, 924, 50 );
  text ("Shots Remaining:", 787, 70);
  text(10-arrayCounter, 923, 70 );
}


void gameWinText() {                            //Displays winning screen
  textSize(130);
  fill(random(255), random(50), random (200));
  //text("YOU WIN",100, 250,-10000);
  text("YOU WIN", 210, 400);
}

void gameLoseText() {                          //Displays losing screen if user has not scored after 10 tries (need to try launching again after the 10th chance to display this)
  textSize(100);
  fill(0);
  //text("YOU WIN",100, 250,-10000);
  text("GAME OVER", 200, 400);

  textSize(50);
  text("TRY AGAIN", 350, 450);
}
