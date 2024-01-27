PVector[] toArray2(ArrayList<PVector> lis){
	PVector[] sol = new PVector[lis.size()];
	for (int i = 0; i<lis.size(); i++){
		sol[i] = lis.get(i);
	} 
	return sol;
}
void drawBox(PVector pos){
	push();
	noFill();
	rectMode(CENTER);
	PVector scl = PVector.sub(new PVector(mouseX, mouseY), pos);
	rect(pos.x+scl.x/2, pos.y+scl.y/2, scl.x, scl.y);
	pop();
}
void addBox(PVector pos){
	PVector[] points = {new PVector(mouseX, mouseY), new PVector(mouseX, pos.y), pos,
		new PVector(pos.x, mouseY)};
	for (int i = 0; i<points.length; i++){
		bounds.add(points[i]);
		if (i != points.length-1){
			bounds.add(points[i+1]);
		} else{
			bounds.add(points[0]);
		}
		
	}
}

class Point2{
    PVector pos;
    ArrayList<PVector> rays = new ArrayList<PVector>();
	ArrayList<Float> meet = new ArrayList<Float>();
    float angle, fow, density;
    Point(PVector xy){
        pos = xy;
        angle = 0;
        fow = 20;
		density = 0.1;
        for (float a = angle; a<angle+fow; a+=density){
            float x = cos(radians(a))*10;
            float y = sin(radians(a))*10;
            rays.add(new PVector(x, y));
        }
    }
	void setAngle(float deg){
		rays.clear();
		angle = deg;
        for (float a = angle; a<angle+fow; a+=density){
            float x = cos(radians(a))*10;
            float y = sin(radians(a))*10;
            rays.add(new PVector(x, y));
        }
	}

    void show(PVector[] walls){
		meet.clear();
        for (int ray = 0; ray<rays.size(); ray++){
			PVector close = null;
			float record = 10000000.0;
			for (int wall = 1; wall<walls.length; wall+=2){
				Float d;
				PVector inter = intersect(pos, PVector.add(rays.get(ray), pos), walls[wall-1], walls[wall]);
				if (inter != null){
					d = dist(pos.x, pos.y, inter.x, inter.y);
					if (d < record){
						record = d;
						close = inter;
					}
				}
			}
			if (close != null){
				line(pos.x, pos.y, close.x, close.y);
				meet.add(dist(pos.x, pos.y, close.x, close.y));
			}

        }

    }

  void update(PVector pos2){
    pos = pos2;
  }
}


PVector intersect(PVector p1, PVector p2, PVector p3, PVector p4){
	float x1 = p3.x;
	float y1 = p3.y;
	float x2 = p4.x;
	float y2 = p4.y;
	
	float x3 = p1.x;
	float y3 = p1.y;
	float x4 = p2.x;
	float y4 = p2.y;
	
	float den = (x1 - x2) * (y3 - y4) - (y1 - y2) * (x3 - x4);
	if (den == 0){
		return null;
	}
	float t = ((x1 - x3) * (y3 - y4) - (y1 - y3) * (x3 - x4)) / den;
	float u = -((x1 - x2) * (y1 - y3) - (y1 - y2) * (x1 - x3)) / den;
	if (0 < t && t < 1 && u > 0){
		PVector sol = new PVector(x1+t*(x2-x1), y1+t*(y2-y1));
		return sol;
	}
	return null;
}

ArrayList<PVector> bounds = new ArrayList<PVector>();
PVector lastPos; 
Point p;
int col = 255;
void setup(){
	fullScreen();
	p = new Point(new PVector(mouseX, mouseY));
	stroke(col);
	lastPos = new PVector(mouseX, mouseY);
	bounds.add(new PVector(0, 0));
	bounds.add(new PVector(width/2, 0));
	bounds.add(new PVector(width/2, 0));
	bounds.add(new PVector(width/2, height));
	bounds.add(new PVector(width/2, height));
	bounds.add(new PVector(0, height));
	bounds.add(new PVector(0, height));
	bounds.add(new PVector(0, 0));
}


void draw(){
	background(abs(col-255));
  	stroke(col);
	p.update(new PVector(mouseX, mouseY));
  	if (mouseX < width/2){
		p.show(toArray2(bounds));
	}
	for (int i = 1; i<bounds.size(); i+=2){
		line(bounds.get(i-1).x, bounds.get(i-1).y, bounds.get(i).x, bounds.get(i).y);
	}
	circle(lastPos.x, lastPos.y, 10);
  	if (keyPressed){
    	if (key == 'a'){
			p.fow += 2;
    		p.setAngle(p.angle);
    	}else if (key == 'd'){
			p.fow -= 2;
      		p.setAngle(p.angle);
		}
		print(p.fow, '\n');
  	}
	if (click){
		drawBox(mPos);
	}
	view(p.meet);
}
boolean click = false;
PVector mPos;
void mousePressed(){
	if (mouseX < width / 2){
		if (click){
			click = false;
			addBox(mPos);
		} else{
			click = true;
      		mPos = new PVector(mouseX, mouseY);
		}
	}
}

void view(ArrayList<Float> lis){
	float scl = width / 2 / float(lis.size());
	float maxD = dist(0, 0, width/2, height);
	for (int i = 0; i < lis.size(); i++){
		int colo = int(map(lis.get(i), 0, maxD, 230, 0));
		int size = int(map(lis.get(i)*lis.get(i), 0, maxD*maxD, height-30, 0));
		push();
		rectMode(CENTER);
		noStroke();
    	fill(colo);
		translate(i*scl+(width/2)+scl/2, height/2);
		rect(0, 0, scl+1, size);
		pop();
	}
}
