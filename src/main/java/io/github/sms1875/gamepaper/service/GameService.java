package io.github.sms1875.gamepaper.service;

import io.github.sms1875.gamepaper.domain.Game;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;

import javax.annotation.PostConstruct;
import java.util.List;
import java.util.Map;
import java.util.concurrent.ConcurrentHashMap;
import java.util.concurrent.CompletableFuture;

@Service
public class GameService {
  private static final Logger logger = LoggerFactory.getLogger(GameService.class);

  private final Map<String, Game> games = new ConcurrentHashMap<>();
  private final List<String> gameNames = List.of(
      // "playblackdesert"
      // "Mabinogi",
      // "MapleStory",
      // "Nikke",
      // "finalfantasy",
      "genshinimpact");
  private int currentIndex = 0;

  /**
   * 초기 게임 목록을 설정하는 메서드.
   * 이 메서드는 빈 초기화 후 자동으로 호출됩니다.
   */
  @PostConstruct
  private void init() {
    gameNames.forEach(this::addGame);
  }

  /**
   * 게임을 목록에 추가하는 메서드.
   * 
   * @param name 추가할 게임의 이름
   */
  public void addGame(String name) {
    games.put(name.toLowerCase(), new Game(name));
  }

  /**
   * 게임 이름으로 게임 객체를 가져오는 메서드.
   * 
   * @param name 게임의 이름
   * @return 게임 객체
   */
  public Game getGame(String name) {
    return games.get(name.toLowerCase());
  }

  /**
   * 모든 게임 목록을 반환하는 메서드.
   * 
   * @return 게임 목록
   */
  public List<Game> getAllGames() {
    return List.copyOf(games.values());
  }

  /**
   * 게임들을 순차적으로 처리하는 메서드.
   */
  public void startSequentialProcessing(GameWallpaperService gameWallpaperService) {
    processNextGame(gameWallpaperService);
  }

  /**
   * 현재 인덱스의 게임을 처리하고, 다음 게임으로 넘어가는 메서드.
   */
  private void processNextGame(GameWallpaperService gameWallpaperService) {
    if (currentIndex < gameNames.size()) {
      String gameName = gameNames.get(currentIndex);
      Game game = getGame(gameName);

      logger.info("Starting to process game: {}", game.getName());

      CompletableFuture<Void> updateTask = gameWallpaperService.updateGameWallpapers(game);
      updateTask.thenRun(() -> {
        logger.info("Finished processing game: {}", game.getName());
        currentIndex++;
        processNextGame(gameWallpaperService); // 다음 게임으로 이동
      }).exceptionally(ex -> {
        logger.error("Error processing game: " + game.getName(), ex);
        currentIndex++;
        processNextGame(gameWallpaperService); // 에러 발생 시에도 다음 게임으로 이동
        return null;
      });
    } else {
      logger.info("All games have been processed.");
    }
  }
}
