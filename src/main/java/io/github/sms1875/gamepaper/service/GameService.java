package io.github.sms1875.gamepaper.service;

import org.springframework.stereotype.Service;
import java.util.List;
import java.util.Map;
import java.util.concurrent.ConcurrentHashMap;

@Service
public class GameService {
  private final Map<String, Game> games = new ConcurrentHashMap<>();

  public GameService() {
    // Initialize with predefined games
    addGame("playblackdesert");
    addGame("Mabinogi");
    addGame("MapleStory");
    addGame("Nikke");
    // addGame("monsterhunter");
    addGame("finalfantasy");
    addGame("genshinimpact");
  }

  public void addGame(String name) {
    games.put(name.toLowerCase(), new Game(name));
  }

  public Game getGame(String name) {
    return games.get(name.toLowerCase());
  }

  public List<Game> getAllGames() {
    return List.copyOf(games.values());
  }

  public static class Game {
    private final String name;
    private GameStatus status;
    private long lastUpdated;

    public Game(String name) {
      this.name = name;
      this.status = GameStatus.EMPTY;
      this.lastUpdated = System.currentTimeMillis();
    }

    // Getters and setters
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

  public enum GameStatus {
    EMPTY, UPDATING, COMPLETED
  }
}