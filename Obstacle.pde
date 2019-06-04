class Obstacle{
  int w;
  int h;
  float posX;
  int type;
  Obstacle(int t){
    posX = width;
    type = t;
    switch(type){
    case 0: 
      w = 40;
      h = 80;
      break;
    case 1:
      w = 60;
      h = 120;
      break;
    case 2:
      w = 120;
      h = 80;
      break;
    }
  }
  
  void show(){
    fill(0);
    rectMode(CENTER);
    switch(type) {
    case 0:
      image(smallCactus, posX - smallCactus.width/2, height - groundHeight - smallCactus.height);
      break;
    case 1:
      image(bigCactus, posX - bigCactus.width/2, height - groundHeight - bigCactus.height);
      break;
    case 2:
      image(manySmallCactus, posX - manySmallCactus.width/2, height - groundHeight - manySmallCactus.height);
      break;
    }
  }
  
  void move(float speed){
    posX -= speed;
  }
 boolean collided(float playerX, float playerY, float playerWidth, float playerHeight) {

    float playerLeft = playerX - playerWidth/2;
    float playerRight = playerX + playerWidth/2;
    float thisLeft = posX - w/2 ;
    float thisRight = posX + w/2;

    if ((playerLeft<= thisRight && playerRight >= thisLeft ) || (thisLeft <= playerRight && thisRight >= playerLeft)) {
      float playerDown = playerY - playerHeight/2;
      float thisUp = h;
      if (playerDown <= thisUp) {
        return true;
      }
    }
    return false;
  }
  

}
