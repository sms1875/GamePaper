package io.github.sms1875.gamepaper.domain;

public class Wallpaper {
  private String url;
  private String gameName;

  public Wallpaper(String url, String gameName) {
    this.url = url;
    this.gameName = gameName;
  }

  public String getUrl() {
    return url;
  }

  public String getGameName() {
    return gameName;
  }
}