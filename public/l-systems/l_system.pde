PFont   font;
ArcBall arcCam;
LSystem system;

boolean recording;
int     growthDelay;
int     currentFrame;
int     currentIteration;

void setup() {
  size(600, 600, P3D);
  smooth();

  camera(300, 300, 525,  // eyeX, eyeY, eyeZ
         300, 300,   0,  // centerX, centerY, centerZ
           0,   1,   0); // upX, upY, upZ
  arcCam = new ArcBall(300, 300, -200, 1000, this);

  font = createFont("Courier",24,true);

  recording        = false;
  growthDelay      = 6;
  currentFrame     = 0;
  currentIteration = 0;

  randomize();
}

void draw() {
  background(0);
  overlayText();

  arcCam.apply();
  system.draw(currentIteration);

  currentFrame++;
  if (currentFrame >= growthDelay &&
      currentIteration < system.iterations) {
    currentIteration++;
    currentFrame = 0;
  }

  if (recording == true) {
    saveFrame("/Users/jackie/code/processing/l_system/image_dump/screen-####.png");
    if (currentIteration >= system.iterations) {
      growthDelay = 6;
      recording   = false;
    }
  }
}

void randomize() {
  system = new LSystem(14);
  system.init();

  currentIteration = 0;
  currentFrame     = 0;
}

/*
   Replaced Vec3 with internal PVector. Added rotateAround() to
   handle missing rotate(a,v0,v1,v2) in Processing.js 1.4.1
   fjenett - 2012-11

   Adapted into Processing library 5th Feb 2006 Tom Carden
   from "simple arcball use template" 9.16.03 Simon Greenwold
   Copyright (c) 2003 Simon Greenwold

   Copyright (c) 2006 Tom Carden
   This library is free software; you can redistribute it and/or
   modify it under the terms of the GNU Lesser General Public
   License as published by the Free Software Foundation; either
   version 2.1 of the License, or (at your option) any later version.
   This library is distributed in the hope that it will be useful,
   but WITHOUT ANY WARRANTY; without even the implied warranty of
   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU
   Lesser General Public License for more details.
   You should have received a copy of the GNU Lesser General
   Public License along with this library; if not, write to the
   Free Software Foundation, Inc., 59 Temple Place, Suite 330,
   Boston, MA 02111-1307 USA
 */

public class ArcBall {
  PGraphics graphics;
  float     center_x, center_y, center_z, radius;
  Quat      q_now, q_down, q_drag;
  PVector   v_down, v_drag;
  PVector[] axisSet;
  int       axis;

  /** defaults to radius of min(width/2,height/2) and center_z of -radius */
  public ArcBall( PApplet parent ) {
    this( parent.g );
  }

  public ArcBall( float center_x, float center_y, float center_z,
                  float radius, PApplet parent ) {
    this( center_x, center_y, center_z, radius, parent.g );
  }

  /** defaults to radius of min(width/2,height/2) and center_z of -radius */
  public ArcBall( PGraphics g ) {
    this( g.width/2.0f, g.height/2.0f, -min( g.width/2.0f, g.height/2.0f ),
          min( g.width/2.0f, g.height/2.0f ), g );
  }

  public ArcBall( float center_x, float center_y, float center_z,
                  float radius, PGraphics g ) {
    graphics      = g;
    this.center_x = center_x;
    this.center_y = center_y;
    this.center_z = center_z;
    this.radius   = radius;
    v_down  = new PVector();
    v_drag  = new PVector();
    q_now   = new Quat();
    q_down  = new Quat();
    q_drag  = new Quat();
    axisSet = new PVector[] {
                new PVector(1.0f, 0.0f, 0.0f),
                new PVector(0.0f, 1.0f, 0.0f),
                new PVector(0.0f, 0.0f, 1.0f)
    };
    axis = -1; // no constraints...

    // this is a hack to initialize it with something .. we can do better
    mousePressed( center_x, center_y );
    mouseDragged( center_x-0.0001, center_y-0.0001 );
  }

  public void reset() {
    arcCam.q_now.reset();
    arcCam.q_down.reset();
    arcCam.q_drag.reset();

    mousePressed( center_x, center_y );
    mouseDragged( center_x-0.0001, center_y-0.0001 );
  }

  public void mousePressed ( float mx, float my ) {
    v_down = mouse_to_sphere( mx, my );
    q_down.set(q_now);
    q_drag.reset();
  }

  public void mouseDragged ( float mx, float my ) {
    v_drag = mouse_to_sphere( mx, my );
    q_drag.set( v_down.dot(v_drag), v_down.cross(v_drag) );
  }

  public void apply () {
    graphics.translate(center_x, center_y, center_z);
    q_now = Quat.mul(q_drag, q_down);
    applyQuat2Matrix(q_now);
    graphics.translate(-center_x, -center_y, -center_z);
  }

  PVector mouse_to_sphere ( float x, float y ) {
    PVector v = new PVector();
    v.x = (x - center_x) / radius;
    v.y = (y - center_y) / radius;
    float m = v.x * v.x + v.y * v.y;
    if (m > 1.0f) {
      v.normalize();
    }
    else {
      v.z = sqrt(1.0f - m);
    }

    return (axis == -1) ? v : constrain_vector(v, axisSet[axis]);
  }

  PVector constrain_vector(PVector vector, PVector axis) {
    PVector res = new PVector();
    axis.mult(axis.dot(vector));
    res.sub(vector, axis);
    res.normalize();

    return res;
  }

  void applyQuat2Matrix(Quat q) {
    // instead of transforming q into a matrix and applying it...
    float[] aa = q.getValue();
    rotateAround( aa[0], aa[1], aa[2], aa[3] );
  }

  void rotateAround ( float angle, float v0, float v1, float v2 ) {
    float norm2 = v0 * v0 + v1 * v1 + v2 * v2;
    if (Math.abs(norm2 - 1) > EPSILON) {
      float norm = sqrt(norm2);
      v0 /= norm;
      v1 /= norm;
      v2 /= norm;
    }

    float cx  = 0;
    float cy  = 0;
    float cz  = 0;
    float c   = cos(angle);
    float s   = sin(angle);
    float t   = 1.0f - c;
    float[] m = new float[9];
    m[0] = (t*v0*v0) + c; // 0, 0
    m[1] = (t*v0*v1) - (s*v2); // 0, 1
    m[2] = (t*v0*v2) + (s*v1); // 0, 2
    m[3] = (t*v0*v1) + (s*v2); // 1, 0
    m[4] = (t*v1*v1) + c; // 1, 1
    m[5] = (t*v1*v2) - (s*v0); // 1, 2
    m[6] = (t*v0*v2) - (s*v1); // 2, 0
    m[7] = (t*v1*v2) + (s*v0); // 2, 1
    m[8] = (t*v2*v2) + c; // 2, 2

    graphics.applyMatrix( m[0], m[1], m[2], 0, m[3], m[4], m[5], 0, m[6], m[7], m[8], 0, 0, 0, 0, 1 );
  }
}

static class Quat {
  float w, x, y, z;

  Quat() {
    reset();
  }

  Quat(float w, float x, float y, float z) {
    this.w = w;
    this.x = x;
    this.y = y;
    this.z = z;
  }

  void reset() {
    w = 1.0f;
    x = 0.0f;
    y = 0.0f;
    z = 0.0f;
  }

  void set ( float w, PVector v ) {
    this.w = w;
    x = v.x;
    y = v.y;
    z = v.z;
  }

  void set( Quat q) {
    w = q.w;
    x = q.x;
    y = q.y;
    z = q.z;
  }

  static Quat mul ( Quat q1, Quat q2 ) {
    Quat res = new Quat();
    res.w = q1.w * q2.w - q1.x * q2.x - q1.y * q2.y - q1.z * q2.z;
    res.x = q1.w * q2.x + q1.x * q2.w + q1.y * q2.z - q1.z * q2.y;
    res.y = q1.w * q2.y + q1.y * q2.w + q1.z * q2.x - q1.x * q2.z;
    res.z = q1.w * q2.z + q1.z * q2.w + q1.x * q2.y - q1.y * q2.x;

    return res;
  }

  float[] getValue() {
    // transforming this quat into an angle and an axis vector...
    float[] res = new float[4];
    float sa = (float) Math.sqrt(1.0f - w * w);
    if (sa < EPSILON) {
      sa = 1.0f;
    }

    res[0] = (float) Math.acos(w) * 2.0f;
    res[1] = x / sa;
    res[2] = y / sa;
    res[3] = z / sa;

    return res;
  }
} // Quat
class LSegment {

  PVector location;
  PVector origin;
  PVector direction;
  int     iteration;
  String  type;

  LSegment(PVector _origin, PVector _direction,
           int _iteration,  String  _type) {

    origin    = _origin;
    location  = _origin.get();
    direction = _direction;
    iteration = _iteration;
    type      = _type;

    updateLocation();
    updateDirection();
    spawn();
  }

  void updateLocation() {
    location.add(direction);
  }

  // determines the graphical meaning of the segment
  // (rotation, length, color, etc)
  void updateDirection() {
    if(type == "A" || type =="F") {
      rotateDirection(system.aRotation.x,
                      system.aRotation.y,
                      system.aRotation.z);
    }
    if(type == "B") {
      rotateDirection(system.bRotation.x,
                      system.bRotation.y,
                      system.bRotation.z);
    }
    if(type == "C") {
      rotateDirection(system.cRotation.x,
                      system.cRotation.y,
                      system.cRotation.z);
    }
  }

  /* production rules (recursive)
   *
   * determines how each segment mutates across iteration.
   * these rules shouldn't belong to the segment but they
   * are needed here since I don't know how to metaprogram
   * in processing
   */
  void spawn() {

    if(iteration < system.iterations-1) {

      if(type == "A") {
        createNextIteration("F");
      }

      if(type == "F") {
        createNextIteration("A");
        createNextIteration("C");
        rotateDirection(0,120,0);
        createNextIteration("C");
        rotateDirection(0,120,0);
        createNextIteration("C");
      }

      if(type == "C") {
        createNextIteration("C");
        createNextIteration("B");
      }

      if(type == "B") {
        createNextIteration("B");
      }
    }
  }

  void display() {
    int vRed   = (system.iterations - iteration)*
                 int(255/system.iterations);
    int vGreen = 255;
    int vBlue  = 255;

    stroke(vRed,vGreen,vBlue);
    strokeWeight(2);
    line(origin.x,   origin.y,   origin.z,
         location.x, location.y, location.z);
  }

  private void createNextIteration(String type) {
    LSegment nextSegment = new LSegment(location.get(), direction.get(),
                                        iteration+1, type);
    system.addSegment(iteration+1, nextSegment);
  }

  private void rotateDirection(float x, float y, float z) {
    sRotateX(direction, radians(x));
    sRotateY(direction, radians(y));
    sRotateZ(direction, radians(z));
  }

  private void sRotateX(PVector vector, float angle) {
    vector.y = vector.y*cos(angle) - vector.z*sin(angle);
    vector.z = vector.y*sin(angle) + vector.z*cos(angle);
  }
  private void sRotateY(PVector vector, float angle) {
    vector.x = vector.x*cos(angle) + vector.z*sin(angle);
    vector.z = -vector.x*sin(angle) + vector.z*cos(angle);
  }
  private void sRotateZ(PVector vector, float angle) {
    vector.x = vector.x*cos(angle) - vector.y*sin(angle);
    vector.y = vector.x*sin(angle) + vector.y*cos(angle);
  }
}
class LSystem {

  ArrayList<ArrayList<LSegment>> segments;
  int iterations;

  Rotation3D aRotation;
  Rotation3D bRotation;
  Rotation3D cRotation;

  PVector    origin;
  PVector    direction;

  /* LSystem constructor
   *
   * creates the outline of a new system by initializing
   * an array for each iteration and randomizing rotation
   * rules.
   *
   * TODO: extract the production rules into this class
   */
  LSystem(int _iterations) {

    iterations  = _iterations;

    // initialize an array of empty arrays
    segments    = new ArrayList<ArrayList<LSegment>>();
    for(int i=0; i<iterations; i++) {
      segments.add(new ArrayList<LSegment>());
    }

    origin      = new PVector(300, 500, -200);
    direction   = new PVector(0,   -50,    0);

    aRotation   = new Rotation3D();
    aRotation.x = random(0,10);
    aRotation.y = random(0);
    aRotation.z = random(-10,10);

    bRotation   = new Rotation3D();
    bRotation.x = random(-30,30);
    bRotation.y = random(-30,30);
    bRotation.z = random(-30,30);

    cRotation   = new Rotation3D();
    cRotation.x = random(-90,90);
    cRotation.y = random(-90,90);
    cRotation.z = random(-90,90);
  }

  /* initialize the system
   *
   * this has to happen in a separate step because the
   * LSegment class needs to call on properties of an already
   * existant system
   */
  void init() {
    // create a proto segment spawns all of it's iterations
    LSegment proto = new LSegment(origin, direction, 0, "A");
    addSegment(0, proto);
  }

  void addSegment(int i, LSegment segment) {
    segments.get(i).add(segment);
  }

  void draw(int n) {
    for(int i=0; i < n; i++){
      for(LSegment s : segments.get(i)) {
        s.display();
      }
    }
  }

}

class Rotation3D {
  public float x;
  public float y;
  public float z;
}
void overlayText() {
  fill(255);
  textFont(font, 24);

  String aData = new String("A ->"  +
                            "  x: " + nfp(system.aRotation.x,2,2) + "°" +
                            "  y: " + nfp(system.aRotation.y,2,2) + "°" +
                            "  z: " + nfp(system.aRotation.z,2,2) + "°");
  String fData = new String("F ->"  +
                            "  x: " + nfp(system.aRotation.x,2,2) + "°" +
                            "  y: " + nfp(system.aRotation.y,2,2) + "°" +
                            "  z: " + nfp(system.aRotation.z,2,2) + "°");
  String bData = new String("B ->"  +
                            "  x: " + nfp(system.bRotation.x,2,2) + "°" +
                            "  y: " + nfp(system.bRotation.y,2,2) + "°" +
                            "  z: " + nfp(system.bRotation.z,2,2) + "°");
  String cData = new String("C ->"  +
                            "  x: " + nfp(system.cRotation.x,2,2) + "°" +
                            "  y: " + nfp(system.cRotation.y,2,2) + "°" +
                            "  z: " + nfp(system.cRotation.z,2,2) + "°");

  text("rules: (A->F),(F->AC+C+C),(C->CB),(B->B)", 10, 20);
  text("start: A, angle: (0,120°,0)", 10, 44);

  text("drawing rules (axis rotation)", 10, 494);
  text(aData, 10, 518, 0);
  text(fData, 10, 542, 0);
  text(bData, 10, 566, 0);
  text(cData, 10, 590, 0);
}

/* user inputs
 *
 * r   -> replay the current system and draw from the beginning
 * c   -> reset the camera to its initial position
 * s   -> save the current frame in the screenshots dir
 * p   -> replay the building of the current system and save each frame
 *        to the image_dump dir
 * ' ' -> randomly create a new system and draw it from stage one
 *
 * mouse press/drag -> send inputs to ArcBall to rotate camera
 */

void keyPressed() {
  if(key == 'r') {
    currentIteration = 0;
  }

  else if(key == 'c') {
    arcCam.reset();
  }

  else if(key == 's') {
    saveFrame("/Users/jackie/code/processing/l_system/screenshots/####.png");
  }

  else if(key == 'p') {
    currentIteration = 0;
    growthDelay      = 0;
    recording        = true;
  }

  else if(key == ' ') {
    randomize();
  }
}

void mousePressed () {
  arcCam.mousePressed(mouseX, mouseY);
}
void mouseDragged () {
  arcCam.mouseDragged(mouseX, mouseY);
}

