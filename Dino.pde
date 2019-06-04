class Dino{
  float fitness;
  boolean replay = false;

  float unadjustedFitness;
  int lifespan = 0;//how long the player lived for fitness
  int bestScore =0;//stores the score achieved used for replay
  boolean dead;
  int score;
  int gen = 0;

  int genomeInputs = 7;
  int genomeOutputs = 3;

  float[] vision = new float[genomeInputs];//t he input array fed into the neuralNet 
  float[] decision = new float[genomeOutputs]; //the out put of the NN 
  //-------------------------------------
  float posY = 0;
  float velY = 0;
  float gravity =1.2;
  int runCount = -5;
  int size = 20;

  ArrayList<Obstacle> replayObstacles = new ArrayList<Obstacle>();
  ArrayList<Bird> replayBirds = new ArrayList<Bird>();
  ArrayList<Integer> localObstacleHistory = new ArrayList<Integer>();
  ArrayList<Integer> localRandomAdditionHistory = new ArrayList<Integer>();
  int historyCounter = 0;
  int localObstacleTimer = 0;
  float localSpeed = 10;
  int localRandomAddition = 0;

  boolean duck= false;
  
  Brain dinoBrain;

  
  Dino(){
    dinoBrain = new Brain(this);
  }
  
  void setBrain(Brain newBrain){
    dinoBrain = newBrain;
  }
  
void show() {
    if (duck && posY == 0) {
      if (runCount < 0) {

        image(dinoDuck, playerXpos - dinoDuck.width/2, height - groundHeight - (posY + dinoDuck.height));
      } else {

        image(dinoDuck1, playerXpos - dinoDuck1.width/2, height - groundHeight - (posY + dinoDuck1.height));
      }
    } else
      if (posY ==0) {
        if (runCount < 0) {
          image(dinoRun1, playerXpos - dinoRun1.width/2, height - groundHeight - (posY + dinoRun1.height));
        } else {
          image(dinoRun2, playerXpos - dinoRun2.width/2, height - groundHeight - (posY + dinoRun2.height));
        }
      } else {
        image(dinoJump, playerXpos - dinoJump.width/2, height - groundHeight - (posY + dinoJump.height));
      }
    runCount++;
    if (runCount > 5) {
      runCount = -5;
    }
  }
  //---------------------------------------------------------------------------------------------------------------------------------------------------------
  
  void incrementCounters() {
    lifespan++;
    if (lifespan % 3 ==0) {
      score+=1;
    }
  }
    void move() {
    posY += velY;
    if (posY >0) {
      velY -= gravity;
    } else {
      velY = 0;
      posY = 0;
    }

    if (!replay) {

      for (int i = 0; i< obstacles.size(); i++) {
        if (obstacles.get(i).collided(playerXpos, posY +dinoRun1.height/2, dinoRun1.width*0.5, dinoRun1.height)) {
          dead = true;
          deathCounter++;
        }
      }

      for (int i = 0; i< birds.size(); i++) {
        if (duck && posY ==0) {
          if (birds.get(i).collided(playerXpos, posY + dinoDuck.height/2, dinoDuck.width*0.8, dinoDuck.height)) {
            dead = true;
            deathCounter++;
          }
        } else {
          if (birds.get(i).collided(playerXpos, posY +dinoRun1.height/2, dinoRun1.width*0.5, dinoRun1.height)) {
            dead = true;
            deathCounter++;
          }
        }
      }
    } else {//if replayign then move local obstacles
      for (int i = 0; i< replayObstacles.size(); i++) {
        if (replayObstacles.get(i).collided(playerXpos, posY +dinoRun1.height/2, dinoRun1.width*0.5, dinoRun1.height)) {
          dead = true;
          deathCounter++;
        }
      }


      for (int i = 0; i< replayBirds.size(); i++) {
        if (duck && posY ==0) {
          if (replayBirds.get(i).collided(playerXpos, posY + dinoDuck.height/2, dinoDuck.width*0.8, dinoDuck.height)) {
            dead = true;
            deathCounter++;
          }
        } else {
          if (replayBirds.get(i).collided(playerXpos, posY +dinoRun1.height/2, dinoRun1.width*0.5, dinoRun1.height)) {
            dead = true;
            deathCounter++;
          }
        }
      }
    }
  }
  
  void jump(boolean bigJump) {
    if (posY ==0) {
      if (bigJump) {
        gravity = 1;
        velY = 20;
      } else {
        gravity = 1.2;
        velY = 16;
      }
    }
  }
  void ducking(boolean isDucking) {
    if (posY != 0 && isDucking) {
      gravity = 3;
    }
    duck = isDucking;
  }
  
  //---------------------------------------------------------------------------------------------------------------------------------------------------------
  //called every frame
  void update() {
    incrementCounters();
    move();
  }
  void updateLocalObstacles() {
    localObstacleTimer ++;
    localSpeed += 0.002;
    if (localObstacleTimer > minimumTimeBetweenObstacles + localRandomAddition) {
      addLocalObstacle();
    }
    groundCounter ++;
    if (groundCounter > 10) {
      groundCounter =0;
      grounds.add(new Ground());
    }

    moveLocalObstacles();
    showLocalObstacles();
  }

  //---------------------------------------------------------------------------------------------------------------------------------------------------------
  void moveLocalObstacles() {
    for (int i = 0; i< replayObstacles.size(); i++) {
      replayObstacles.get(i).move(localSpeed);
      if (replayObstacles.get(i).posX < -100) {
        replayObstacles.remove(i);
        i--;
      }
    }

    for (int i = 0; i< replayBirds.size(); i++) {
      replayBirds.get(i).move(localSpeed);
      if (replayBirds.get(i).posX < -100) {
        replayBirds.remove(i);
        i--;
      }
    }
    for (int i = 0; i < grounds.size(); i++) {
      grounds.get(i).move(localSpeed);
      if (grounds.get(i).posX < -100) {
        grounds.remove(i);
        i--;
      }
    }
  }
  void addLocalObstacle() {
    int tempInt = localObstacleHistory.get(historyCounter);
    localRandomAddition = localRandomAdditionHistory.get(historyCounter);
    historyCounter ++;
    if (tempInt < 3) {
      replayBirds.add(new Bird(tempInt));
    } else {
      replayObstacles.add(new Obstacle(tempInt -3));
    }
    localObstacleTimer = 0;
  }
  void showLocalObstacles() {
    for (int i = 0; i< grounds.size(); i++) {
      grounds.get(i).show();
    }
    for (int i = 0; i< replayObstacles.size(); i++) {
      replayObstacles.get(i).show();
    }

    for (int i = 0; i< replayBirds.size(); i++) {
      replayBirds.get(i).show();
    }
  }
  
  void calculateFitness(){
    fitness = score * score;
  }
}
