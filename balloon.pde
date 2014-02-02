class Balloon {

  float balloonX;
  float balloonY;
  PImage balloonImage;




  Balloon(String balloonImageName, float balloonX, float balloonY) {
    this.balloonX= balloonX;
    this.balloonY=balloonY;
    this.balloonImage=loadImage(balloonImageName);
  }

  void draw() {
    image(balloonImage, balloonX, balloonY);
  }
}

