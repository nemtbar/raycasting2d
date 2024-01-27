PVector[] rays = new PVector[36];

void setup(){
  size(400, 400);
  for (int i = 0; i<360; i+=10){
    float x = cos(radians(i))*30;
    float y = sin(radians(i))*30;
    rays[i/10] = new PVector(x, y);
  }
}

void draw(){
    background(0);
    stroke(255);
    for (PVector ray : rays){
      PVector self = PVector.add(new PVector(mouseX, mouseY), ray);
      line(mouseX, mouseY, self.x, self.y);
    }
}
