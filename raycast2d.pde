class Point{
    ArrayList<PVector> walls = new ArrayList<PVector>();
    ArrayList<PVector> rays = new ArrayList<PVector>();
    //list of the lengths of the rays
    ArrayList<Float> dis = new ArrayList<Float>();
    float angle, fow, density, space;
    PVector pos;
    Point(PVector po, float spac){
        angle = 0;
        fow = 45;
        density = 0.2;
        pos = po;
        space = spac;
        addBox(new PVector(0, 0), new PVector(space, height));
        createRays();

    }

    void createRays(){
        rays.clear();
        for (float i = angle; i<angle+fow; i+=density){
            float x = cos(radians(i));
            float y = sin(radians(i));
            rays.add(new PVector(x, y));
        }
    }

    void show(){
        dis.clear();
        //draw walls
        for(int i = 1; i<walls.size(); i+=2){
            line(walls.get(i-1).x, walls.get(i-1).y, walls.get(i).x, walls.get(i).y);
        }
        if (mouseX > space){
            return;
        }
        //draw rays
        for(int ray = 0; ray<rays.size(); ray++){
            float record = 10000000.0;
            PVector closest = null;
            for(int wall = 1; wall<walls.size(); wall+=2){
                PVector inter = intersect(PVector.add(rays.get(ray), pos), walls.get(wall-1), walls.get(wall));
                if (inter != null){
                    //decide which is the closest wall
                    float d = dist(inter.x, inter.y, pos.x, pos.y);
                    if (d < record){
                        record = d;
                        closest = inter;
                    }

                }
            }
            if (closest != null){
                line(pos.x, pos.y, closest.x, closest.y);
                dis.add(dist(pos.x, pos.y, closest.x, closest.y));
            }
        }
    }

    void update(float x, float y){
        pos = new PVector(x, y);
    }

    PVector intersect(PVector ray, PVector wallA, PVector wallB){
        float x1 = wallA.x;
        float y1 = wallA.y;
        float x2 = wallB.x;
        float y2 = wallB.y;
        
        float x3 = pos.x;
        float y3 = pos.y;
        float x4 = ray.x;
        float y4 = ray.y;
        
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
    void addWall(PVector a, PVector b){
        walls.add(a);
        walls.add(b);
    }
    void addBox(PVector a, PVector b){
        PVector[] points = {a, new PVector(a.x, b.y), b, new PVector(b.x, a.y)};
        for (int i = 0; i<points.length; i++){
            if (i != points.length-1){
                addWall(points[i], points[i+1]);
            }else{
                addWall(points[i], points[0]);
            }
        }
    }

    void view(){
        float scl = (width-space)/float(dis.size());
        float maxD = dist(width, height, space, 0);
        for (int i = 0; i<dis.size(); i++){
            int colo = int(map(dis.get(i), 0, maxD, 255, 0));
            int size = int(map(dis.get(i), 0, maxD, height, 0));
            push();
            noStroke();
            rectMode(CENTER);
            fill(colo);
            rect(i*scl+space+(scl/2), height/2, scl+1, size);
            pop();
        }
    }

    void rot(char a, char d){
        if (keyPressed){
            if (key == a){
                angle -= 3;
                createRays();
            }else if (key == d){
                angle += 3;
                createRays();
            }
        }
    }
    
    void move(char w, char s){
        if (keyPressed){
            if (key == w){
                float dirA = angle + fow/2;
                PVector dirV = PVector.fromAngle(radians(dirA)).setMag(6);
                pos.add(dirV);
            }else if (key == s){
                float dirA = angle + fow/2;
                PVector dirV = PVector.fromAngle(radians(dirA)).setMag(6);
                pos.sub(dirV);
            }
        }
    }

}

Point p;
PVector mPos;
boolean click = false; 
void setup() {
    fullScreen();
    p = new Point(new PVector(mouseX, mouseY), width/2);
    //p.addBox(new PVector(0, 0), new PVector(width, height));
}

void draw() {
    background(0);
    stroke(255);
    //p.update(mouseX, mouseY);
    //rotate
    p.rot('a', 'd');
    p.move('w', 's');
    p.show();
    flor(p.space);
    p.view();
    if (click){
        noFill();
        beginShape();
        vertex(mouseX, mouseY);
        vertex(mPos.x, mouseY);
        vertex(mPos.x, mPos.y);
        vertex(mouseX, mPos.y);
        endShape(CLOSE);
        fill(255);
    }

}

void mousePressed(){
    if (click){
        p.addBox(mPos, new PVector(mouseX, mouseY));
        click = false;
    }else{
        click = true;
        mPos = new PVector(mouseX, mouseY);
    }
}

void flor(float space){
    float scl = height/2/255.0; 
    for (int i = 0; i<255; i++){
        push();
        rectMode(CENTER);
        noStroke();
        fill(map(i, 0, 255, 255, 0));
        rect(space+(width-space)/2, height-i*scl, width-space, scl+1);
        pop();
    }
}
