// Importing Sound
import processing.sound.*;

//SoundFile file;

public int[][]map=new int[160][32];
public int levelNumber = 0;
ArrayList<Enemy> enemies = new ArrayList<>();
String[] levelNames = new String[] {"lvl1.csv", "lvl2.csv", "lvl3.csv", "lvl4.csv", "lvl5.csv", "lvl6.csv", "lvl7.csv", "lvl8.csv", "lvl9.csv", "lvl10.csv", "lvl11.csv", "lvl12.csv"};
PImage ground, spike, player, enemy, downSpike, finish, upb, down, lava, open, ws, water, penemy, benemy;
Player p;
float scroll = 0;
int sec = 0;
boolean home = true;

void setup() {

  size(640, 640);

  ground = loadImage("Ground.png");
  spike = loadImage("Spikes.png");
  player = loadImage("Player.png");
  enemy = loadImage("Enemy.png");
  downSpike = loadImage("downSpike.png");
  finish = loadImage("Finish.png");
  upb = loadImage("Up.png");
  down = loadImage("Down.png");
  lava = loadImage("Lava.png");
  ws = loadImage("WaterSpike.png");
  water = loadImage("Water.png");
  penemy = loadImage("Penemy.png");
  benemy = loadImage("Benemy.png");
  open = loadImage("OpeningImage.png");
  map = parseCSV(levelNames[levelNumber]);
  p = new Player(32, 288, player);
  loadLevel(levelNumber);

  // Adding Sound
  //file = new SoundFile(this, "Mission.mp3");
  // TO DO: add loop in draw() which will play sound every 60*51 frames,
  //file.play();
}
void loadLevel(int level) {
  levelNumber = level;
  map = parseCSV(levelNames[levelNumber]);
  enemies = new ArrayList<Enemy>();
  scroll = 0;
  for (int i = 0; i < map.length; i++) {
    for (int j = 0; j < map[i].length; j++) {
      if (map[i][j] == 3) {
        enemies.add(new Enemy(j, i, enemy, 1.75));
      }
      if (map[i][j] == 11) {
        enemies.add(new Enemy(j, i, penemy, 2.25));}
      if (map[i][j] == 12) {
        enemies.add(new Enemy(j, i, benemy, 2.75));}
    }
  }
  scroll = 0;
  p = new Player(0, 288, player);
}

void draw() {
  sec+=1;
  if (sec == 51*60) {
    //file.play();
    sec=0;
  }
  if (home) {
    image(open, 0, 0, 640, 640);
    fill(255, 255, 255);
    textSize(30);
    text("Press 'space' to start", 170, 320);
  } else {
    background(255, 255, 255);
    textSize(30);
    fill(0, 0, 0);
    text("Press 'r' to restart", 230, 75);
    //Handles player controls and gravity
    p.update();
    //Move the player based on vx and vy

    scroll+=p.move();



    //Draw the
    p.draw(scroll);
    println(scroll);
    for (Enemy e : enemies) {
      e.move();
      e.draw(scroll);
    }
    



    //IN HERE, SUBTRACT SCROLLX from X val, and ADD SCROLL Y TO Y VAL

    //Draws The map
    for (int i = 0; i < map.length; i++) {
      for (int j = 0; j < map[i].length; j++) {
        int curtile = map[i][j];
        if (curtile == -1) {
        } else if (curtile == 0) {
          image(ground, j*32 - scroll, i*32);
        } else if (curtile == 1) {
          image(spike, j*32 - scroll, i*32);
        } else if (curtile == 4) {
          image(downSpike, j*32 - scroll, i*32);
          //rect(j*32 - scroll + 11, i*32, 7,13);
        } else if (curtile == 5) {
          image(finish, j*32 - scroll, i *32);
        } else if (curtile == 6) {
          image(upb, j*32 - scroll, i * 32);
        } else if (curtile == 7) {
          image(down, j*32 - scroll, i * 32);
        } else if (curtile == 8) {
          image(lava, j*32 - scroll, i * 32);
        } else if (curtile == 9) {
          image(ws, j*32 - scroll, i * 32);
          //rect(j*32 - scroll + 12, i*32 + 17, 7,13);
        } else if (curtile == 10) {
          image(water, j*32 - scroll, i * 32);
         
        } 
      }
    }
  }
}

void keyPressed() {
  if (keyCode == UP || keyCode == ' ') {
    p.jump= true;
  }

  if (keyCode == LEFT || key == 'a') {
    p.left = true;
  }

  if (keyCode == RIGHT ||key == 'd' ) {
    p.right = true;
  }

  if (key == 'r') {
    scroll=0;

    //THIS IS WHERE THE PLAYER RESPAWNS
    p = new Player(0, 288, player);
    //file.stop();
  }

  if (key == '1') {
    loadLevel(0);
  }
  if (key == '2') {
    loadLevel(1);
  }
  if (key == '3') {
    loadLevel(2);
  }
  if (key == '4') {
    loadLevel(3);
  }
  if (key == '5') {
    loadLevel(4);
  }
  if (key == '6') {
    loadLevel(5);
  }
  if (key == '7') {
    loadLevel(6);
  }
  if (key == '8') {
    loadLevel(7);
  }
  if (key == '9') {
    loadLevel(8);
  }
  if (key == '0') {
    loadLevel(9);
  }
  if (key == 'q' || key== 'Q') {
    loadLevel(10);
  }
  if (key == 'e' || key== 'E') {
    loadLevel(11);
  }
  
  if (key == ' ' && home) {
    home = false;
  }
}
void keyReleased() {
  if (keyCode == UP || keyCode == ' ') {
    p.jump= false;
  }
  if (keyCode == LEFT || key =='a') {
    p.left = false;
  }

  if (keyCode == RIGHT || key =='d') {
    p.right = false;
  }
}



public int[][] parseCSV(String path) {
  String[] lines = loadStrings(path);
  int[][] data = new int[lines.length][ lines[0].length()];
  for (int i = 0; i < lines.length; i++) {
    String[] lineData = lines[i].split(",");
    for (int j = 0; j < lineData.length; j++) {
      data[i][j] = Integer.parseInt(lineData[j]);
    }
  }
  return data;
}
