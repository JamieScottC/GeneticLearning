class Obstacle{
  int w = 40;
  int h = 40;
  float posX = 0;
  float speed = 5;
  Obstacle(){
    posX = (width + w);
  }
  
  void show(){
    fill(0);
    rectMode(CENTER);
    rect(posX, height - 100 - (h/2), w, h);
  }
  
  void move(){
    posX -= speed;
  }


}
