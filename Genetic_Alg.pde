Dino dino;
Obstacle ob;
void setup(){
  size(800, 400);
  dino = new Dino();
  ob = new Obstacle();
}


void draw(){
  background(255);
  stroke(0);
  line(0, height - 100, width, height - 100);
  dino.move();
  dino.show();
  ob.show();
  ob.move();
}

void keyPressed(){
  switch(key){
    case '0':
      if(dino.posY == 0){
        dino.velY = 10;
      }
  }
}
