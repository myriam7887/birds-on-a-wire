class Button {


  PImage buttonImage;
  PImage rollButtonImage;

  float x;
  float y; 

  float w;
  float h;


  Button(String buttonImageName, String rollButtonImageName, float x, float y) {

    this.buttonImage=loadImage(buttonImageName);
    this.rollButtonImage=loadImage(rollButtonImageName);
    this.x=x;
    this.y=y;

    this.w=this.buttonImage.width;
    this.h=this.buttonImage.height;
  }

  void draw() {

    if (isMouseOver()) {
      image(rollButtonImage, x, y);
    }
    else {
      image(buttonImage, x, y);
    }
  }

  boolean isMouseOver() {

    return mouseX>x && mouseX<x+w && mouseY>y && mouseY<y+h;
  }
}

