package io.github.sms1875.gamepaper.domain;

public class Game {
  private final String name;
  private GameStatus status;
  private long lastUpdated;

  public Game(String name) {
    this.name = name;
    this.status = GameStatus.EMPTY;
    this.lastUpdated = System.currentTimeMillis();
  }

  public String getName() {
    return name;
  }

  public GameStatus getStatus() {
    return status;
  }

  public void setStatus(GameStatus status) {
    this.status = status;
    this.lastUpdated = System.currentTimeMillis();
  }

  public long getLastUpdated() {
    return lastUpdated;
  }
}
