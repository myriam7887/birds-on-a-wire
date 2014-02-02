import twitter4j.conf.*;
import twitter4j.internal.async.*;
import twitter4j.internal.org.json.*;
import twitter4j.internal.logging.*;
import twitter4j.json.*;
import twitter4j.internal.util.*;
import twitter4j.management.*;
import twitter4j.auth.*;
import twitter4j.api.*;
import twitter4j.util.*;
import twitter4j.internal.http.*;
import twitter4j.*;
import twitter4j.internal.json.*;


PImage birdsTitle;
PImage bg;
PImage multipleBirdsImage;
PImage birdImage;
PImage poemPaperImage;
PFont font;
PFont font2;
// The font must be located in the sketch's 
// "data" directory to load successfully


boolean viewPoem=false;

ArrayList<Position> positions= new ArrayList();

ArrayList<Balloon> balloons = new ArrayList();

ArrayList<Poem> poems = new ArrayList();
int currentTweetIndex=0;
int savedTweetsLimit=6;


ArrayList<String> suggestedTweets = new ArrayList();
ArrayList<String> savedTweets = new ArrayList();

//Initializing Array with lineHeights values
//same as   lineHeights[0]=firstvalue;
//          lineHeights[1]=secondvalue;
int[] lineHeights = new int[] {
  124, 266, 503, 667, 776
};


Button[] buttons;
Button saveButton;
Button skipButton;
//button multiple birds
Button backButton;


void setup() {
  size(1420, 835);
  background(255);
  smooth();
  font = loadFont("MenschRegular-48.vlw");
  font2 = loadFont("PopplExquisit-Regular-48.vlw");
  birdsTitle = loadImage("bird-title.png");
  bg = loadImage("birds-on-balloons.png");
  multipleBirdsImage = loadImage("multiple-wires.png");
  birdImage= loadImage("bird.png");
  poemPaperImage= loadImage("poemback-trans.png");

  balloons.add(new Balloon("balloon-orange1.png", 646, 78));
  balloons.add(new Balloon("balloon-blue2.png", 731, 34));
  balloons.add(new Balloon("balloon-purple3.png", 834, 31));
  balloons.add(new Balloon("balloon-yellow4.png", 903, 66));
  balloons.add(new Balloon("balloon-green5.png", 999, 73));
  balloons.add(new Balloon("balloon-red6.png", 1070, 116));


  buttons = new Button[2];
  saveButton= new Button("button-save.png", "button-save-roll.png", 1170, 390); 
  buttons[0]= saveButton;
  skipButton= new Button("button-skip.png", "button-skip-roll.png", 1283, 390);
  buttons[1]=skipButton;

  backButton= new Button("button-back.png", "button-back-roll.png", 42, 636);

  //iterating through all combinations of x and y of possible positions for the birds
  for (int i=0; i<7; i++) { //we have 7 different x positions per line (x)
    for (int j=0; j<lineHeights.length; j++) { // iterating through all lines (y)
      float positionX=i*200+20; //birds are separated horizontally by 200 and left margin is 20
      float positionY=lineHeights[j];//taking the line' height
      positions.add(new Position(positionX, positionY));
    }
  }
  //randomizing the order of positions
  Collections.shuffle(positions);





  ConfigurationBuilder cb = new ConfigurationBuilder();
  cb.setOAuthConsumerKey("Eo1hpg1k5wu2Pd6ymbpF9Q");
  cb.setOAuthConsumerSecret("8FeqieOYSxfjf1ev65oFAOeIqUFdVIvLsirDZpEc");
  cb.setOAuthAccessToken("227268667-wDmA96Mzxiz921D1LRghQ5MxPjwvNi1mfoY0sESc");
  cb.setOAuthAccessTokenSecret("qPNl9BWn7wfbmKBTxCOzZ56qqpNKcoidvc4ImaGFfs");


  Twitter twitter = new TwitterFactory(cb.build()).getInstance();
  List<String> hashtags = Arrays.asList(new String[] {
    "#imissyou", "#missingyou", "#firstlove", "#forgiveme", "#iloveyou", "#sad", "#dontleaveme", "#loveyou", "#death", "#maybesomeday", "#ldr", "#ineedyou", "#myangel", "#imsorry", "#iwishyouwerehere", "#wishyouwerehere", "#goodbye"
  }
  );
  List<Query> queries = new ArrayList();
  for (String hashtag: hashtags) {
    Query query = new Query(hashtag);
    query.setRpp(100); 
    queries.add(query);
  }


  try {
    for (Query query: queries) {
      QueryResult result = twitter.search(query);
      ArrayList<Tweet> tweets = (ArrayList) result.getTweets();
      for (Tweet tweet: tweets) {
        String msg =tweet.getText();
        // replace first username by you
        msg = msg.replaceFirst("\\@\\w+", "you");
        // keep only some hashtags
        msg = msg.replaceAll("#goodbye", "goodbye");

        // cleaning
        msg = msg.replaceAll("#\\w+|@\\w+|http:\\S+|<<|>|!|\\.", "");
        // squeezing spaces
        msg = msg.replaceAll("[\\s\\r\\n]+", " ");

        // remove retweets, only take between 10 and 80 characters
        if (msg.startsWith("RT") == false && msg.length() > 10 && msg.length() < 70) {
          suggestedTweets.add(msg);
        }
      }
    }

    Collections.shuffle(suggestedTweets);

    for (String suggestedTweet: suggestedTweets) {
      println(suggestedTweet);
    }
  } 
  catch (TwitterException te) {
    println("Couldn't connect: " + te);
  }
};

void draw() {

  if (viewPoem) {
    background(multipleBirdsImage);
    backButton.draw();
    //forloop to call birds - poems
    //to avoid having the birds be over the paper, draw all the birds first, then the paper.
    for (Poem poem:poems) {
      poem.drawBird();
    } 
    for (Poem poem:poems) {
      poem.drawPaper();
    }
  }
  else {

    background(bg);
    //draw balloons as many as we have saved tweets and make sure we have enough balloons.
    for (int i=0; i<savedTweets.size() && i<balloons.size(); i++) {
      Balloon balloon=balloons.get(i);
      balloon.draw();
    }
    image(birdsTitle, 387, 119);


    for (Button button:buttons) {
      button.draw();
    }

    //Draw a word from the list of words that we've built

    String suggestedTweet = suggestedTweets.get(currentTweetIndex);

    //text fony size and color;
    fill(0);
    textFont(font, 24);


    text(suggestedTweet, 326, height/2-10);
  }
}

void mousePressed () {

  //TODO remove
  println("" + mouseX + "," + mouseY);
  if (viewPoem) {

    if (backButton.isMouseOver()) {
      viewPoem=false;
    }
  }
  else {
    if (skipButton.isMouseOver()) {
      currentTweetIndex++;
    }

    if (saveButton.isMouseOver()) {
      String selectedTweet = suggestedTweets.get(currentTweetIndex);    
      savedTweets.add(selectedTweet);
      currentTweetIndex++;
      println(savedTweets);

      if (savedTweets.size()== savedTweetsLimit) {
        // page with poem, page with birds go here.
        //use the first position after shuffle and remove it afterwards
        Position pickedPosition= positions.remove(0);
        float poemX=pickedPosition.positionX;
        float poemY=pickedPosition.positionY;
        //50% chance to flip - otherwise keep it UNFLIPPED
        boolean flipBird=random(0, 1)<0.5;
        //scales between half size and full size of bird.
        float scaleBird= random(0.35, 1);
        Poem poem = new Poem(savedTweets, poemX, poemY, flipBird, scaleBird);
        poems.add(poem);
        viewPoem=true;
        savedTweets = new ArrayList();
      }
    }
  }
}

