String handleError(Object error) {
  String errorMessage = error.toString();

  if (errorMessage.contains('network-request-failed')) {
    return "인터넷 연결이 원활하지 않습니다. 네트워크를 확인한 후 다시 시도해주세요.";
  } else if (errorMessage.contains('unauthorized') || errorMessage.contains('permission-denied') || errorMessage.contains('storage/unauthorized') || errorMessage.contains('app-check-error')) {
    return "앱 인증에 실패했습니다. 잠시 후 다시 시도하거나 지원팀에 문의해주세요.";
  } else if (errorMessage.contains('storage/object-not-found')) {
    return "요청하신 파일을 찾을 수 없습니다. 파일을 확인한 후 다시 시도해주세요.";
  } else if (errorMessage.contains('storage/quota-exceeded')) {
    return "저장소 용량을 초과했습니다. 잠시 후 다시 시도해주세요.";
  } else if (errorMessage.contains('storage/retry-limit-exceeded') || errorMessage.contains('storage/unknown')) {
    return "서버에 문제가 발생했습니다. 잠시 후 다시 시도해주세요.";
  } else if (errorMessage.contains('storage/invalid-checksum')) {
    return "파일 다운로드 링크가 만료되었습니다. 새 링크로 다시 시도해주세요.";
  } else if (errorMessage.contains('no-games-available')) {
    return "현재 이용할 수 있는 게임이 없습니다. 나중에 다시 확인해주세요.";
  } else if (errorMessage.contains('no-wallpapers-available')) {
    return "사용할 수 있는 월페이퍼가 없습니다.";
  } else if (errorMessage.contains('no-wallpapers-for-this-page')) {
    return "이 페이지에는 월페이퍼가 없습니다.";
  } else {
    return "알 수 없는 오류가 발생했습니다. 다시 시도해주세요.";
  }
}
