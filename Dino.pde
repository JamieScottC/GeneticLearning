class Dino{
  float posY = 0;
  float posX = 0;
  float gravity = 0.6;
  float velY = 0;
  
  int size = 50;
  Dino(){
  
  }
  
  void show(){
    fill(0);
    rectMode(CENTER);
    
    rect(50, height - 100 - (posY + size), size, size + 50);
  }
  
  
  void move(){
    posY += velY;
    if(posY > 0){
      velY -= gravity;
    }else{
      velY = 0;
      posY = 0;
    }
  }
}
