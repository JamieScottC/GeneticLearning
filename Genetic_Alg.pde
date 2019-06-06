ArrayList<Obstacle> obstacles = new ArrayList<Obstacle>();
ArrayList<Dino> testingDinos = new ArrayList<Dino>();

//images
PImage dinoRun1;
PImage dinoRun2;
PImage dinoJump;
PImage dinoDuck;
PImage dinoDuck1;
PImage smallCactus;
PImage manySmallCactus;
PImage bigCactus;
PImage bird;
PImage bird1;

boolean showNothing = false;
boolean betterGen = false;

int numBetterGens = 0;

int groundHeight = 150;
int obstacleTimer = 0;
float speed = 10;
int playerXpos = 150;
int minimumTimeBetweenObstacles = 60;
int randomAddition = 0;
int groundCounter = 0;
int deathCounter = 0;

int gameTime = 0;
int gameScore = 0;
int bestScore = 0;
int lastScore = 0;
int staleCounter = 0;

Dino bestOverallDino = new Dino();

public int gen = 1;

int[] fitnessNumberLine;
int totalFitness;

ArrayList<Ground> grounds = new ArrayList<Ground>();
ArrayList<Bird> birds = new ArrayList<Bird>();
ArrayList<Integer> obstacleHistory = new ArrayList<Integer>();
ArrayList<Integer> randomAdditionHistory = new ArrayList<Integer>();

void setup(){
  //size(800, 500);
  fullScreen();
  dinoRun1 = loadImage("dinorun0000.png");
  dinoRun2 = loadImage("dinorun0001.png");
  dinoJump = loadImage("dinoJump0000.png");
  dinoDuck = loadImage("dinoduck0000.png");
  dinoDuck1 = loadImage("dinoduck0001.png");

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
  
  gameTime++;
  if(gameTime % 3 == 0){
    gameScore++;
  }
 
  fill(200);
  textSize(40);
  textAlign(LEFT);
  text("Score: " + gameScore, 30, height - 50);
  text("Gen: " + gen, width - 175, height - 50);
  text("Best Score: " + bestScore, width / 4, height - 50);
  text("Dinos Left: " + (testingDinos.size() - deathCounter), width / 2, height - 50);
 
  for(int i = 0; i < testingDinos.size(); i++){
    if(!testingDinos.get(i).dead){
      testingDinos.get(i).move();
      testingDinos.get(i).show();
      testingDinos.get(i).incrementCounters();
      if(obstacles.size() >= 1){
        //println("The neural net has lit up node: " + testingDinos.get(i).dinoBrain.fireTheNet());
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

void updateAnalytics(){
  textAlign(LEFT);
  if(betterGen){
    text("Gen " + gen, 30, numBetterGens * 40);
    numBetterGens++;
  }
}

void chooseDinoMovement(int n, Dino dino){
  switch(n){
    case 0:
    if(dino.posY == 0){
        dino.jump(true);
      }
      break;
    case 1:
    break;
    case 2:
    if(dino.posY == 0){
        dino.jump(false);
      }
    break;
    case 3:
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
  speed += 0.002;
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
  int lifespan = testingDinos.get(1).lifespan;
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
  for(int i = 0; i < 500; i++){
    testingDinos.add(new Dino());
  }
  fitnessNumberLine = new int[testingDinos.size()];
  
}

float[] getData(Dino myDino){
  float[] data = new float[7];
  
  if(disToNextObstacle() <= disToNextBird()){
    data[0] = 1.0 - ((disToNextObstacle()) / (width - playerXpos)); //Distance to next obstacle
    data[1] = obstacles.get(0).h / 120.0; //Obstacle height
    data[2] = obstacles.get(0).w / 120.0; //Obstacle width
    data[3] = speed / 100; //Speed
    data[4] = myDino.posY / 150; //Current y position of Dino
    data[5] = 1.0; //Bias
    data[6] = 0.0; //Default y-height of obstacle
  }
  else{
    println("I've detected a bird");
    data[0] = 1.0 - ((disToNextBird()) / (width - playerXpos)); //Distance to next obstacle
    data[1] = birds.get(0).h / 50.0; //Obstacle height
    data[2] = birds.get(0).w / 60.0; //Obstacle width
    data[3] = speed / 100; //Speed
    data[4] = myDino.posY / 150; //Current y position of Dino
    data[5] = 1.0; //Bias
    data[6] = birds.get(0).posY; //Default y-height of obstacle
  }
  
  return data;
}

void isAllDead(){
  if(deathCounter >= testingDinos.size()){
    restart();
    fitnessLine();
    learning();
  }
}

void restart(){
  if(gameScore > bestScore){
    bestScore = gameScore;
    staleCounter = 0;
    betterGen = true;
    updateAnalytics();
  }
  else{
    staleCounter++;
  }
  lastScore = gameScore;
  
  groundHeight = 150;
  obstacleTimer = 0;
  speed = 10;
  playerXpos = 150;
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
      int chosenDinoInd = 0;
      float rand = random(totalFitness);
      for(int k = 0; k < fitnessNumberLine.length; k++){
        if(rand <= fitnessNumberLine[k]){
          chosenDinoInd = k;
          break;
        }
      }
      
      //changingDino = testingDinos.get(chosenDinoInd).clone();
      
      if(staleCounter >= 10){
        changingDino = bestOverallDino.clone();
      }
      else{
        changingDino = mostFit;
      }
      
      for(int j = 1; j < changingDino.dinoBrain.neuralNet.size(); j++){
        //changingDino.dinoBrain.neuralNet.get(j).mutate(testingDinos.get(i).fitness);
        if(staleCounter == 10){
          changingDino.dinoBrain.neuralNet.get(j).mutate(bestScore);
        }
        else{
          changingDino.dinoBrain.neuralNet.get(j).mutate(lastScore);
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

void fitnessLine(){
  totalFitness = 0;
  for(int i = 0; i < testingDinos.size(); i++){
    totalFitness += testingDinos.get(i).fitness;
    fitnessNumberLine[i] = totalFitness;
  }
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
