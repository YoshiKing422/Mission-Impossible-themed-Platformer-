class Enemy {
  float vx, x, y, lb, rb;
  PImage sprite;

  Enemy(int xtile, int ytile, PImage sprite) {
    x = xtile * 32;
    y = ytile * 32;
    vx = 1.75 * neg1or1();
    this.sprite= sprite;
    while (map[ytile + 1][xtile] == 0) {
      xtile -- ;
    }
    lb = (xtile + 1) * 32;
    xtile ++;
    while (map[ytile + 1][xtile] == 0) {
      xtile ++;
    }
    rb = (xtile - 1) * 32;
  }
  void draw (float scroll) {
    image(sprite, x - scroll, y );
  }
  void move() {
    if (x+vx<lb || x+vx>rb) {
      vx*=-1;
    }
    x += vx;
  }
  int neg1or1() {
    return Math.random() > 0.5 ? -1 : 1;
  }
}
