

class Poem {

  ArrayList<String> tweets;
  float birdX;
  float birdY;
  float birdW;
  float birdH;
  boolean flipBird;



  Poem(ArrayList<String> tweets, float birdX, float lineHeight, boolean flipBird, float scaleBird) {
    this.tweets= tweets;
    this.birdX=birdX;
    //the y coordinate of the bird is the lineHeight adjusted for the space between the bottom of the image and the feet of the bird.
    this.birdY=lineHeight-(birdImage.height-15)*scaleBird; 
    this.birdW=birdImage.width*scaleBird;
    this.birdH=birdImage.height*scaleBird;
    this.flipBird=flipBird;
  }

  void drawBird() {
    pushMatrix();
    if (flipBird) {
      scale(-1, 1);
      translate(-birdW, 0);
      image(birdImage, -birdX, birdY, birdW, birdH);
    }
    else {
      image(birdImage, birdX, birdY, birdW, birdH);
    }
    popMatrix();
    //reset scale.
    scale(1, 1);
  }

  void drawPaper() {
    if (isMouseOverBird()) {
      float poemPaperX;
      if (birdX<width/2) { //the bird is on the left half of the screen
        //paper is on the right of the bird
        poemPaperX= birdX+birdW+20;
      }
      else { //the bird is on the right
        //paper is on the left of the bird
        poemPaperX= birdX-poemPaperImage.width-20;
      }
      //place the poem window next to the bird.
      float poemPaperY;
      if (birdY<height/2) { //the bird is on the top half of the screen
        poemPaperY = birdY;
      }
      else { // the bird is on the bottom side of the screen
        poemPaperY = birdY + birdH - poemPaperImage.height;
      }
      image(poemPaperImage, poemPaperX, poemPaperY);
      fill(0);
      textFont(font2, 22);
      for (int i=0; i<tweets.size();i++) {
        String tweet = tweets.get(i);
        //left margin, top margin, and line separation
        text(tweet, poemPaperX+70, poemPaperY+120+40*i);
      }
    }
  }

  boolean isMouseOverBird() {

    return mouseX>birdX && mouseX<birdX+birdW && mouseY>birdY && mouseY<birdY+birdH;
  }
}

