class Player {
  float x, y, vx, vy, xsign, ysign;
  PImage sprite;
  boolean left = false, right = false, jump = false, grounded = true, jumping = false, ba = false, bouncing = false, fall = false, inWater= false;


  Player(float x, float y, PImage image) {
    this.x=x;
    this.y=y;
    sprite = image;
  }
  void update() {
    inWater = false;
    if (left) {
      vx=-5;
    } else if (right) {
      vx=5;
    } else if (!left && !right) {
      vx= 0;
    }
    if (inWater) {
  grounded = false; // Only set grounded to false if in water, after all checks
}
    if (jump && (grounded || inWater)) {
  if (inWater) {
    vy = -15; // stronger jump in water
  } else {
    vy = -7;
  }
  grounded = false;
  jumping = true;
} else {
      jumping = false;
    }
    if (jump && abs(vy) < 15) {
      vy -= 0.2;
    }
    vy +=.5;

    if (vx > 0)
      xsign = 1;
    if (vx < 0)
      xsign = -1;
    if (vy > 0)
      ysign = 1;
    if (vy < 0)
      ysign = -1;

    //loop through all da block bruh
    for (int ytile = 0; ytile < map.length; ytile++) {
      for (int xtile = floor(scroll / 32); xtile < floor (scroll / 32 + width / 32); xtile++) {
        //check if colliding yo
        if (isColliding(x+vx, y+vy, 32, 32, xtile * 32, ytile * 32, 32, 32)) {

          //da block bruh
          if (map[ytile][xtile] == 0) {

            //move you out of the x dir
            if (isColliding(x + vx, y, 32, 32, xtile * 32, ytile * 32, 32, 32)) {
              int count = 0;
              while (count < 50 && !isColliding(x + xsign, y, 32, 32, xtile * 32, ytile * 32, 32, 32)) {
                x+=xsign;
                count++;
              }
              vx = 0;
            }
            //move you out of the y dir
            if (isColliding(x, y + vy, 32, 32, xtile * 32, ytile * 32, 32, 32)) {
              int count = 0;
              while (count < 50 &&!isColliding(x, y + ysign, 32, 32, xtile * 32, ytile * 32, 32, 32)) {
                y+=ysign;
                count++;
              }

              if (vy > 0) {
                grounded = true;
                vy = 0;
              } else
                vy = .5;
            }
          }
        }
        //spike
        if (map[ytile][xtile] == 1) {

          if (isColliding(x, y, 32, 32, xtile*32 + 13, ytile *32 + 20, 7, 10)) {
            //restart
            scroll=0;
            p = new Player(0, 288, player);
          }
        }
        //down spike
        if (map[ytile][xtile] == 4) {

          if (isColliding(x, y, 32, 32, xtile*32 + 11, ytile *32, 7, 13)) {

            scroll=0;
            p = new Player(0, 288, player);
          }
        }
        //finish block
        if (map[ytile][xtile] == 5) {

          if (isColliding(x, y, 32, 32, xtile*32, ytile *32, 32, 32)) {
            loadLevel(++levelNumber);
          }
        }

        //bounce
        if (map[ytile][xtile] == 6) {

          if (!bouncing && isColliding(x +vx, y+vy + 0.2, 32, 32, xtile*32, ytile *32, 32, 32) && y <= ytile *32 ) {
            vy=-12;
            grounded = false;
            jumping = true;
            bouncing = true;
          } else {
            bouncing = false;
          }
        }

        //down bounce
        if (map[ytile][xtile] == 7) {

          if (!fall && isColliding(x, y+vy, 32, 32, xtile*32, ytile *32, 32, 32) && y <= ytile *32 ) {
            vy=+12;
            grounded = false;
            jumping = true;
            fall = true;
          } else {
            fall = false;
          }
        }
      
        //lava
        if (map[ytile][xtile] == 8) {
  
          if (isColliding(x, y, 32, 32, xtile*32 + 13, ytile *32 + 20, 7, 10)) {
            //restart
            scroll=0;
            p = new Player(0, 288, player);
          
          }
        }
        //water spike
        if (map[ytile][xtile] == 9) {

          if (isColliding(x, y, 32, 32, xtile*32 + 12, ytile *32 + 17, 7, 13)) {
            vx*=0.85;
            if (vy > 0) { // Only slow falling, not jumping
      vy *= 0.93; // Try 0.93 for a gentler slow
    }
            inWater = true;
            scroll=0;
            p = new Player(0, 288, player);
          }
        }
        // water block (10): slow player and make them fall (not grounded)
        if (map[ytile][xtile] == 10) {
          if (isColliding(x, y, 32, 32, xtile*32, ytile*32, 32, 32)) {
            vx *= 0.85;
            if (vy > 0) { // Only slow falling, not jumping
      vy *= 0.93; // Try 0.93 for a gentler slow
    }
            inWater = true;
          }
        }
      }
      if (vy > 0)
        grounded = false;

      for (Enemy e : enemies) {
        if (isColliding(x+vx, y+vy, 32, 32, e.x + e.vx, e.y, 32, 32)) {
          scroll=0;
          p = new Player(0, 288, player);
        }
     
  
      }
    }
  }
  float move () {
    x+=vx;
    y+=vy;
    if (y > height -32) {
      y = height - 32;
      grounded = true;
    }
    if (x >= 300 && scroll <= 4155)
      return vx;

    return 0;
  }

  void draw(float scroll) {
    image(sprite, x - scroll, y );
  }
  boolean isColliding(float x1, float y1, float w1, float h1, float x2, float y2, float w2, float h2) {
    return x1 < x2+ w2 && y1 < y2+h2 && x2 < x1 + w1 && y2 < y1 + h1;
  }
}
