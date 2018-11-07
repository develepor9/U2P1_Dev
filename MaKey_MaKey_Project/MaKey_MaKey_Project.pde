// for sound
import processing.sound.*;
SoundFile file;
String audioName = "hit sound.mp3";
String audioNameTwo = "Clapsound.mp3";
String path;

// images
PImage playerOne = null;
PImage playerTwo = null;
PImage swordHorizontal = null;
PImage swordVertical = null;
PImage clap = null;

// ints that need to be 'public'
int scene = 1; 
int poneScore = 0;
int ptwoScore = 0;
int roundNumber =0;
int switchScreenTime;
int clickTime1;
int clickTime2;
int wClickNum =0;
int spaceClickNum =0;
int frameNum =0;

void setup()
{
  background (0);
  size (900, 600);
  // person is 200 wide, ratio is 1.777
  playerOne = loadImage ("person.png");
  playerTwo = loadImage ("person.png");
  swordHorizontal = loadImage ("sword horizontal.png");
  swordHorizontal.resize(177, 100);
  swordVertical = loadImage ("sword vertical.png");
  swordVertical.resize(100, 177);
  clap = loadImage ("claphand.png");
  clap.resize(100, 100);
}

void draw()
{
  if (scene == 1)
  {
    sceneOne();
  }
  if (scene == 2)
  {
    sceneTwo();
  }
  if (scene == 3)
  {
    sceneThree();
  }
  if (scene == 4)
  {
    sceneFour();
  }
}

// Instructions 
void sceneOne()
{
  background (0);
  textAlign(CENTER);

  // title
  textSize (22);
  text ("Instructions", 300, 150, 300, 300);

  // main text body
  String instructions = "One person put on the 'gloves'. The other pick up the 'sword'. To score points the player "
    +"wearing the gloves must clap at the same time the other person hits the foil contact spot with the 'sword'." 
    +" Press 'S' to continue.";
  textSize(16);
  text (instructions, 300, 190, 300, 300);

  // continue button
  if (keyPressed)
  {
    if (key == 's' || key == 'S')
    {
      scene = 2;
    }
  }
}

// Main Game
void sceneTwo()
{ 
  background (255);
  imageMode (CENTER);
  textAlign (CENTER, CENTER);
  textSize (22);
  noStroke();

  //ends the game after 10 rounds
  if (roundNumber > 10)
  {
    scene = 4;
  }
  // calls the switch sides screen half way through the game
  if (roundNumber == 5)
  {
    switchScreenTime = millis();
    scene = 3;
  }
  //swithes the positions of p1 and p2 after 5 rounds
  if (roundNumber > 5)
  {
    fill (0);
    text ("Player 1", 650, 100, 100, 100);
    text ("Score: "+poneScore, 650, 150, 100, 100);
    text ("Player 2", 150, 100, 100, 100);
    text ("Score: "+ptwoScore, 150, 150, 100, 100);
  } else
  {
    fill (0);
    text ("Player 1", 150, 100, 100, 100);
    text ("Score: "+poneScore, 150, 150, 100, 100);
    text ("Player 2", 650, 100, 100, 100);
    text ("Score: "+ptwoScore, 650, 150, 100, 100);
  }
  // drawing the images
  image (playerOne, 200, 450);
  image (playerTwo, 700, 450);
  image (swordVertical, 290, 370);

  if (keyPressed)
  {
    if (key == 'w' || key == 'W')
    { 
      //the clicknum ints make sure you can't hold down the key
      if (wClickNum < 1)
      {
        clickTime1 = millis();
        fill (255);
        rect (255, 281, 100, 177);
        image (swordHorizontal, 370, 430);
        wClickNum++;
      }
    }
    if (key == ' ')
    {
      if (spaceClickNum < 1)
      {
        clickTime2 = millis();
        image (clap, 590, 420);
        spaceClickNum++;
      }
    }
  }
  
  frameNum++;
  
  if (frameNum > 59 && (clickTime1 != 0 || clickTime2 != 0))
  {
    frameNum =0;
    int timeDifference = clickTime1-clickTime2;
  
    if (abs(timeDifference) <100)
    {
      if (roundNumber >5)
      {
        poneScore ++;
      } else if (roundNumber < 6)
      {
        ptwoScore ++;
      }
      roundNumber ++;
      path = sketchPath(audioNameTwo);
      file = new SoundFile(this, path);
      file.play();
      clickTime1 = 0;
      clickTime2 = 0;
      wClickNum = 0;
      spaceClickNum = 0;
      int currentTime = millis();
      while ((millis() - currentTime) < 2000)
      {
        text ("      CAUGHT!      Time Difference: "+timeDifference, 325, 100, 150, 100);
      }
    } else if (abs(timeDifference) >74)
    {
      if (roundNumber >5)
      {
        ptwoScore ++;
      } else if (roundNumber < 6)
      {
        poneScore ++;
      }
      roundNumber ++;
      path = sketchPath(audioName);
      file = new SoundFile(this, path);
      file.play();
      clickTime1 = 0;
      clickTime2 = 0;
      wClickNum = 0;
      spaceClickNum = 0;
      int currentTime = millis();
      while ((millis() - currentTime) < 2000)
      {
        text ("        HIT!        Time Difference: "+timeDifference, 325, 100, 150, 100);
      }
    }
   }
}

//Switch sides screen
void sceneThree()
{
  // makes sure this screen displays for two seconds
  if ((millis()-switchScreenTime) > 2000)
  {
    roundNumber +=1;
    scene =2;
  }

  background (0);
  fill (255);
  textSize(25);
  textAlign (CENTER, CENTER);
  text ("Switch Roles", 350, 200, 200, 200);
}

// Score screen
void sceneFour()
{
  background (0);
  fill (255);
  textSize (25);
  textAlign (CENTER, CENTER);

  //checks who has the higher score and then makes them the winner
  if (poneScore > ptwoScore)
  {
    text ("Player 1 is the winner with a score of "+poneScore+" to "+ptwoScore, 350, 200, 200, 200);
  } else if (poneScore < ptwoScore)
  {
    text ("Player 2 is the winner with a score of "+ptwoScore+" to "+poneScore, 350, 200, 200, 200);
  } else
  {
    text ("It is a tie!", 350, 200, 200, 200);
  }
}
