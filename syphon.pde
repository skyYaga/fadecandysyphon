import codeanticode.syphon.*;

OPC opc;
PImage img;
SyphonClient client;
int ledLength = 1440;
color pixelcolor;

void setup() {
  size(240, 600, P3D);
  
  opc = new OPC(this, "fadecandy-server.local", 7890);
  for(int i=0; i<24; i++) {
    opc.ledStrip(i * 60, 60, i * width / 24.0 + width / 48.0,
      height * 0.5, width / 24.0, PI * 0.5, false);
  }
  
  // Create syhpon client to receive frames 
  // from the first available running server: 
  client = new SyphonClient(this);
}

void draw() {
  background(0);
  if (client.newFrame()) {
    // The first time getImage() is called with 
    // a null argument, it will initialize the PImage
    // object with the correct size.
    img = client.getImage(img); // load the pixels array with the updated image info (slow)
    //img = client.getImage(img, false); // does not load the pixels array (faster)   
    
  
    // Draw the result
    image(img, 0, 0, width, height);
  
    //setLEDS();
  
    //for (int i = 0; i < ledLength; i++) { // iterate through the frame horizontally and draw dots where the leds will be relatively
    //  fill(255);
    //  ellipse( (width/ledLength) * i, height/2, 4, 4);
    //}
    
    //display the framerate
    //textSize(32);
    //fill(255);
    //text(frameRate, 10, 40);
  }
  if (img != null) {
    image(img, 0, 0, width, height);  
  }
}

void setLEDS() {
  
  for (int i = 0; i < ledLength; i++) { // iterate through the frame horizontally
    pixelcolor = img.get((img.width/ledLength) * i, img.height/2); // read the color per pixel
    float r = red(pixelcolor);
    float g = green(pixelcolor);
    float b = blue(pixelcolor);
    opc.setPixel(i, color(g, r, b)); //these leds mix up colors somehow
  }
  opc.writePixels(); //sending buffer to the fadecandy
}

void keyPressed() {
  if (key == ' ') {
    client.stop();  
  } else if (key == 'd') {
    println(client.getServerName());
  }
}
