class StopWatchTimer {
  int timer = 30 * 60 * 1000; // 30 minutes
  int startTime = 0;
  int stopTime = 0;
  int prevTime = 0;
  int lastSecond;
  int lastMinute;
  float posX;
  float posY;
  boolean running = false;

  StopWatchTimer(float x, float y) {
    posX = x;
    posY = y;
  }

  void display() {
    String displayMinutes;
    String displaySeconds;
    if (getMinute() < 10) {
      displayMinutes = "0" + str(getMinute());
    } else {
      displayMinutes = str(getMinute());
    }
    if (getSecond() < 10) {
      displaySeconds = "0" + str(getSecond());
    } else {
      displaySeconds = str(getSecond());
    }
    fill(0);
    textSize(32);
    text(displayMinutes + ":" + displaySeconds, posX, posY + 12);
  }

  void start() {
    startTime = millis();
    running = true;
  }
  void restart() {
    timer += millis() - prevTime;
    running = true;
  }
  void stop() {
    lastSecond = getSecond();
    lastMinute = getMinute();
    running = false;
    prevTime = millis() - startTime;
  }
  int getElapsedTime() {
    int elapsed;
    if (running) {
      elapsed = timer - (millis() - startTime);
    } else {
      elapsed = timer - (stopTime - startTime);
    }
    return elapsed;
  }
  int getSecond() {
    if (running) {
      return (getElapsedTime() / 1000) % 60;
    }
    return lastSecond;
  }
  int getMinute() {
    if (running) {
      return (getElapsedTime() / (1000 * 60)) % 60;
    }
    return lastMinute;
  }
}
