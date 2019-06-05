class Dino{
  float fitness;
  
  int lifespan = 0;//how long the player lived for fitness
  boolean dead;
  int score;

  float posY = 0;
  float velY = 0;
  float gravity =1.2;
  int runCount = -5;
  int size = 20;

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
      }else{
        image(dinoDuck1, playerXpos - dinoDuck1.width/2, height - groundHeight - (posY + dinoDuck1.height));
      }
    }else{
      if (posY ==0) {
        if (runCount < 0){
          image(dinoRun1, playerXpos - dinoRun1.width/2, height - groundHeight - (posY + dinoRun1.height));
        }else{
          image(dinoRun2, playerXpos - dinoRun2.width/2, height - groundHeight - (posY + dinoRun2.height));
        }
      }else{
        image(dinoJump, playerXpos - dinoJump.width/2, height - groundHeight - (posY + dinoJump.height));
      }
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
    
    if (posY >0){
      velY -= gravity;
    }else{
      velY = 0;
      posY = 0;
    }

    for (int i = 0; i< obstacles.size(); i++) {
      if (obstacles.get(i).collided(playerXpos, posY +dinoRun1.height/2, dinoRun1.width*0.5, dinoRun1.height)) {
        dead = true;
        calculateFitness();
        deathCounter++;
      }
    }

    for (int i = 0; i< birds.size(); i++){
      if (duck && posY ==0){
        if (birds.get(i).collided(playerXpos, posY + dinoDuck.height/2, dinoDuck.width*0.8, dinoDuck.height)){
          dead = true;
          calculateFitness();
          deathCounter++;
        }
          
      }else{
        if (birds.get(i).collided(playerXpos, posY +dinoRun1.height/2, dinoRun1.width*0.5, dinoRun1.height)) {
          dead = true;
          calculateFitness();
          deathCounter++;
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
  
  Dino clone(){
    Dino clone = new Dino();
    clone.dinoBrain = dinoBrain.clone(this);
    return clone;
  }
  
  void calculateFitness(){
    fitness = score * score;
  }
  
}
