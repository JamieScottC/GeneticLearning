Dino dino;
ArrayList<Obstacle> obstacles = new ArrayList<Obstacle>();

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

int groundHeight = 250;
int obstacleTimer = 0;
float speed = 10;
int playerXpos = 150;
int minimumTimeBetweenObstacles = 60;
int randomAddition = 0;
int groundCounter = 0;


ArrayList<Ground> grounds = new ArrayList<Ground>();
ArrayList<Bird> birds = new ArrayList<Bird>();
ArrayList<Integer> obstacleHistory = new ArrayList<Integer>();
ArrayList<Integer> randomAdditionHistory = new ArrayList<Integer>();

void setup(){
  size(800, 500);
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
  dino = new Dino();
}


void draw(){
  drawToScreen();  
  dino.move();
  dino.show();
  updateObstacles();
  
}
void drawToScreen() {
  if (!showNothing) {
    background(250); 
    stroke(0);
    strokeWeight(2);
    line(0, height - groundHeight - 30, width, height - groundHeight - 30);
  }
}

void keyPressed(){
  switch(key){
    case '0':
      if(dino.posY == 0){
        dino.jump(true);
      }
      break;
    case '9':
    if(dino.posY == 0){
        dino.jump(false);
      }
    break;
    case '8':
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
  println(speed);
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
  int lifespan = dino.lifespan;
  int tempInt;
  if (lifespan > 1000 && random(1) < 0.15) { // 15% of the time add a bird
    tempInt = floor(random(3));
    Bird temp = new Bird(tempInt);//floor(random(3)));
    birds.add(temp);
  } else {//otherwise add a cactus
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
