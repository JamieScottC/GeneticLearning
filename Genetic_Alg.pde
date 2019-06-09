ArrayList<Obstacle> obstacles = new ArrayList<Obstacle>();
ArrayList<Dino> testingDinos = new ArrayList<Dino>();

//images
PImage dinoRun1Global;
PImage dinoRun2Global;
PImage dinoJumpGlobal;
PImage dinoDuckGlobal;
PImage dinoDuck1Global;

PImage smallCactus;
PImage manySmallCactus;
PImage bigCactus;
PImage bird;
PImage bird1;

boolean showNothing = false;
boolean betterGen = false;

int groundHeight = 150;
int obstacleTimer = 0;
float speed = 10;
int playerXpos = 100;
int minimumTimeBetweenObstacles = 60;
int randomAddition = 0;
int groundCounter = 0;
int deathCounter = 0;

int gameTime = 0;
int gameScore = 0;
int bestScore = 0;
int lastScore = 0;
int staleCounter = 0;

int bird1Counter = 0;
int bird2Counter = 0;
int bird3Counter = 0;

Dino bestOverallDino = new Dino();

public int gen = 1;

float[] dataList;

ArrayList<Ground> grounds = new ArrayList<Ground>();
ArrayList<Bird> birds = new ArrayList<Bird>();
ArrayList<Integer> obstacleHistory = new ArrayList<Integer>();
ArrayList<Integer> randomAdditionHistory = new ArrayList<Integer>();

void setup(){
  //size(800, 500);
  fullScreen();
  dinoRun1Global = loadImage("dinorun0000.png");
  dinoRun2Global = loadImage("dinorun0001.png");
  dinoJumpGlobal = loadImage("dinoJump0000.png");
  dinoDuckGlobal = loadImage("dinoduck0000.png");
  dinoDuck1Global = loadImage("dinoduck0001.png");

  smallCactus = loadImage("cactusSmall0000.png");
  bigCactus = loadImage("cactusBig0000.png");
  manySmallCactus = loadImage("cactusSmallMany0000.png");
  bird = loadImage("berd.png");
  bird1 = loadImage("berd2.png");
  
  makeTheDinos();
}

void draw(){
  drawToScreen();  
  updateObstacles();
  isAllDead();
  updateText();
  
  gameTime++;
  if(gameTime % 3 == 0){
    gameScore++;
  } 
 
  for(int i = 0; i < testingDinos.size(); i++){
    if(!testingDinos.get(i).dead){
      testingDinos.get(i).move();
      testingDinos.get(i).show();
      testingDinos.get(i).incrementCounters();
      
      if(obstacles.size() >= 1 || birds.size() >= 1){
        chooseDinoMovement(testingDinos.get(i).dinoBrain.fireTheNet(), testingDinos.get(i));
      }
    }
  }
}

void drawToScreen() {
  if (!showNothing) {
    background(250); 
    stroke(0);
    strokeWeight(2);
    line(0, height - groundHeight - 30, width, height - groundHeight - 30);
  }
}

void updateText(){
  fill(200);
  textSize(40);
  textAlign(LEFT);
  text("Score: " + gameScore, 30, height - 50);
  text("Gen: " + gen, width - 200, height - 50);
  text("Best Score: " + bestScore, width / 4, height - 50);
  text("Dinos Left: " + (testingDinos.size() - deathCounter), width / 2, height - 50);
  
  /*text("Weights:", 30, 60);
  text("Biases:", 1000, 60);
  text("Activations:", 1250, 60);
  
  text("Do Nothing", 1450, 120);
  text("Big Jump", 1450, 180);
  text("Small Jump", 1450, 240);
  text("Duck", 1450, 300);
  
  for(int i = 0; i < testingDinos.get(firstAliveDino()).dinoBrain.neuralNet.get(1).size; i++){
    text(testingDinos.get(firstAliveDino()).dinoBrain.neuralNet.get(1).biases[i], 1100, (i + 2) * 60);
    text(testingDinos.get(firstAliveDino()).dinoBrain.neuralNet.get(1).activations[i], 1300, (i + 2) * 60);
    for(int j = 0; j < testingDinos.get(firstAliveDino()).dinoBrain.neuralNet.get(1).lastNL.size; j++){
      text(testingDinos.get(firstAliveDino()).dinoBrain.neuralNet.get(1).weights[i][j], ((i + 1) * 200), ((j + 2) * 60));
    }
  }*/
  
  /*
  if(disToNextObstacle() <= disToNextBird() && obstacles.size() >= 1){
    text("Distance to Next Obstacle: " + disToNextObstacle(), 30, 60);
    text("--> " + (1.0 - ((disToNextObstacle()) / (width - playerXpos))), 775, 60);
  
    text("Obstacle Height: " + obstacles.get(0).h, 30, 120);
    text("--> " + (obstacles.get(0).h / 120.0), 775, 120);
  
    text("Obstacle Width: " + obstacles.get(0).w, 30, 180);
    text("--> " + (obstacles.get(0).w / 120.0), 775, 180);
    
    text("Speed: " + speed, 30, 240);
    text("--> " + (speed / 175), 775, 240);
    
    text("Dino Y-Position: " + testingDinos.get(firstAliveDino()).posY, 30, 300);
    text("--> " + (testingDinos.get(firstAliveDino()).posY / 210.0), 775, 300);
    
    text("Obstacle Y-Position: " + 35.0, 30, 360);
    text("--> " + (1.0 - (35.0 / 180.0)), 775, 360);
    
    text("The Next Obstacle is a:", 1350, 100);
    text("Cactus", 1500, 160);
  }
  else if(birds.size() >= 1){
    text("Distance to Next Obstacle: " + disToNextBird(), 30, 60);
    text("--> " + (1.0 - ((disToNextBird()) / (width - playerXpos))), 775, 60);
  
    text("Obstacle Height: " + birds.get(0).h, 30, 120);
    text("--> " + (birds.get(0).h / 120.0), 775, 120);
  
    text("Obstacle Width: " + birds.get(0).w, 30, 180);
    text("--> " + (birds.get(0).w / 120.0), 775, 180);
    
    text("Speed: " + speed, 30, 240);
    text("--> " + (speed / 175), 775, 240);
    
    text("Dino Y-Position: " + testingDinos.get(firstAliveDino()).posY, 30, 300);
    text("--> " + (testingDinos.get(firstAliveDino()).posY / 210.0), 775, 300);
    
    text("Obstacle Y-Position: " + birds.get(0).posY, 30, 360);
    text("--> " + (1.0 - (birds.get(0).posY / 180.0)), 775, 360);
    
    text("The Next Obstacle is a:", 1350, 100);
    text("Bird", 1550, 160);
  }else{
    text("Distance to Next Obstacle: 0", 30, 60);
    text("--> 0", 775, 60);
  
    text("Obstacle Height: 0", 30, 120);
    text("--> 0", 775, 120);
  
    text("Obstacle Width: 0", 30, 180);
    text("--> 0", 775, 180);
    
    text("Speed: 0", 30, 240);
    text("--> 0", 775, 240);
    
    text("Dino Y-Position: 0", 30, 300);
    text("--> 0", 775, 300);
    
    text("Obstacle Y-Position: 0", 30, 360);
    text("--> 0", 775, 360);
    
    text("The Next Obstacle is a:", 1350, 100);
    text("Nothing", 1500, 160);
  }*/
}

void chooseDinoMovement(int n, Dino dino){
  switch(n){
    case 0:
    //text("Ding", 1700, 120);
    break;
    case 1:
    //text("Ding", 1700, 180);
    if(dino.posY == 0){
        dino.jump(true);
      }
      break;
    case 2:
    //text("Ding", 1700, 240);
    if(dino.posY == 0){
        dino.jump(false);
      }
    break;
    case 3:
    //text("Ding", 1700, 300);
      if(dino.duck){
        dino.ducking(false);
      }else{
        dino.ducking(true);
      }
    break;
  }
}

void updateObstacles() {
  obstacleTimer ++;
  speed += 0.02;
  if (obstacleTimer > minimumTimeBetweenObstacles + randomAddition) { //if the obstacle timer is high enough then add a new obstacle
    addObstacle();
  }
  
  groundCounter ++;
  
  if (groundCounter> 10) { //every 10 frames add a ground bit
    groundCounter =0;
    grounds.add(new Ground());
  }

  moveObstacles();//move everything
  if (!showNothing) {//show everything
    showObstacles();
  }
}

void moveObstacles() {
  for (int i = 0; i< obstacles.size(); i++) {
    obstacles.get(i).move(speed);
    if (obstacles.get(i).posX < -playerXpos) { 
      obstacles.remove(i);
      i--;
    }
  }

  for (int i = 0; i< birds.size(); i++) {
    birds.get(i).move(speed);
    if (birds.get(i).posX < -playerXpos) {
      birds.remove(i);
      i--;
    }
  }
  
  for (int i = 0; i < grounds.size(); i++) {
    grounds.get(i).move(speed);
    if (grounds.get(i).posX < -playerXpos) {
      grounds.remove(i);
      i--;
    }
  }
}

void addObstacle() {
  int tempInt;
  if (gameTime > 1000 && random(1) < 0.15){ // 15% of the time add a bird
    tempInt = floor(random(3));
    Bird temp = new Bird(tempInt);//floor(random(3)));
    birds.add(temp);
  }else{//otherwise add a cactus
    tempInt = floor(random(3));
    Obstacle temp = new Obstacle(tempInt);//floor(random(3)));
    obstacles.add(temp);
    tempInt+=3;
  }
  obstacleHistory.add(tempInt);

  randomAddition = floor(random(50));
  randomAdditionHistory.add(randomAddition);
  obstacleTimer = 0;
}

void showObstacles() {
  for (int i = 0; i< grounds.size(); i++) {
    grounds.get(i).show();
  }
  for (int i = 0; i< obstacles.size(); i++) {
    obstacles.get(i).show();
  }
  for (int i = 0; i< birds.size(); i++) {
    birds.get(i).show();
  }
}

void resetObstacles() {
  randomAdditionHistory = new ArrayList<Integer>();
  obstacleHistory = new ArrayList<Integer>();

  obstacles = new ArrayList<Obstacle>();
  birds = new ArrayList<Bird>();
  obstacleTimer = 0;
  randomAddition = 0;
  groundCounter = 0;
  speed = 10;
}

void makeTheDinos(){
  for(int i = 0; i < 1000; i++){
    testingDinos.add(new Dino());
    
    if(i == 0){
      testingDinos.get(i).dinoRun1 = loadImage("dinorunG0000.png");
      testingDinos.get(i).dinoRun2 = loadImage("dinorunG0001.png");
      testingDinos.get(i).dinoJump = loadImage("dinoJumpG0000.png");
      testingDinos.get(i).dinoDuck = loadImage("dinoduckG0000.png");
      testingDinos.get(i).dinoDuck1 = loadImage("dinoduckG0001.png");
    }
    else{
      testingDinos.get(i).dinoRun1 = dinoRun1Global;
      testingDinos.get(i).dinoRun2 = dinoRun2Global;
      testingDinos.get(i).dinoJump = dinoJumpGlobal;
      testingDinos.get(i).dinoDuck = dinoDuckGlobal;
      testingDinos.get(i).dinoDuck1 = dinoDuck1Global;
    }
  }

}

float[] getData(Dino myDino){
  float[] data = new float[8];
  
  if(obstacles.size() == 0 && birds.size() == 0){
    for(int i = 0; i < 8; i++){
      data[i] = 0.0;
    }
  }
  else if(disToNextObstacle() <= disToNextBird()){
    data[0] = 1.0 - ((disToNextObstacle()) / (width - playerXpos)); //Distance to next obstacle
    data[1] = obstacles.get(0).h / 120.0; //Obstacle height
    data[2] = obstacles.get(0).w / 120.0; //Obstacle width
    data[3] = speed / 175; //Speed
    data[4] = myDino.posY / 215.0; //Current y position of Dino
    data[5] = 1.0; //Bias
    data[6] = 1.0 - (35.0 / 180.0); //Default y-height of obstacle
    data[7] = 0.0;  //Is Bird
  }
  else{
    data[0] = 1.0 - ((disToNextBird()) / (width - playerXpos)); //Distance to next obstacle
    data[1] = birds.get(0).h / 120.0; //Obstacle height
    data[2] = birds.get(0).w / 120.0; //Obstacle width
    data[3] = speed / 175; //Speed
    data[4] = myDino.posY / 215.0; //Current y position of Dino
    data[5] = 1.0; //Bias
    data[6] = (1.0 - ((birds.get(0).posY) / 180.0)); //Default y-height of obstacle
    data[7] = 1.0; //Is Bird
  }
  
  return data;
}

void isAllDead(){
  if(deathCounter >= testingDinos.size()){
    restart();
    learning();
  }
}

void restart(){
  if(gameScore > bestScore){
    bestScore = gameScore;
    staleCounter = 0;
    betterGen = true;
  }
  else{
    staleCounter++;
  }
  
  lastScore = gameScore;
  
  groundHeight = 150;
  obstacleTimer = 0;
  speed = 10;
  playerXpos = 100;
  minimumTimeBetweenObstacles = 60;
  randomAddition = 0;
  groundCounter = 0;
  deathCounter = 0;
  gameTime = 0;
  gameScore = 0;
  
  obstacles.clear();
  birds.clear();
}

void learning(){
    Dino mostFit = testingDinos.get(0);
        
    for(int i = 0; i < testingDinos.size(); i++){
      if(testingDinos.get(i).fitness > bestOverallDino.fitness){
        bestOverallDino = testingDinos.get(i);
      }
      
      if(testingDinos.get(i).fitness > mostFit.fitness){
        mostFit = testingDinos.get(i);
      }
    }

    Dino changingDino; 
    gen++;
    
    for(int i = 0; i < testingDinos.size(); i++){
      
      if(staleCounter >= 10){
        changingDino = bestOverallDino.clone();
      }
      else{
        changingDino = mostFit.clone();
      }
      
      for(int j = 1; j < changingDino.dinoBrain.neuralNet.size(); j++){
        if(staleCounter >= 10){
          changingDino.dinoBrain.neuralNet.get(j).mutate(bestScore, staleCounter);
        }
        else{
          changingDino.dinoBrain.neuralNet.get(j).mutate(lastScore, staleCounter);
        }
      }
      
      changingDino.fitness = 0;
      changingDino.lifespan = 0;
      changingDino.dead = false;
      changingDino.score = 0;
      changingDino.posY = 0;
      changingDino.velY = 0;
      changingDino.gravity = 1.2;
      changingDino.runCount = -5; 
      
      testingDinos.set(i, changingDino);
    }
    
    if(staleCounter >= 10){
      staleCounter = 0;
    }
}

int firstAliveDino(){
  for(int i = 0; i < testingDinos.size(); i++){
    if(!testingDinos.get(i).dead){
      return i;
    }
  }
  return 0;
}

float disToNextObstacle(){
  for(int i = 0; i < obstacles.size(); i++){
    if((obstacles.get(i).posX - playerXpos) > 0){
      return (obstacles.get(i).posX - playerXpos);
    }
  }
  return 2000;
}

float disToNextBird(){
  for(int i = 0; i < birds.size(); i++){
    if((birds.get(i).posX - playerXpos) > 0){
      return (birds.get(i).posX - playerXpos);
    }
  }
  return 2000;
}

float sigmoid(float x){
  return (float)(1/( 1 + Math.pow(Math.E,(-1*x))));  
}
