package io.github.sms1875.gamepaper.service.firebase;

import com.google.cloud.storage.Blob;
import com.google.cloud.storage.BlobId;
import com.google.cloud.storage.BlobInfo;
import com.google.cloud.storage.Storage;
import com.google.firebase.cloud.StorageClient;
import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartFile;

import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

@Service
public class FirebaseStorageService {
  private final Storage storage;

  public FirebaseStorageService() {
    this.storage = StorageClient.getInstance().bucket().getStorage();
  }

  public String uploadFile(byte[] fileData, String fileName, String game, String type) throws IOException {
    String path = "games/" + game + "/" + type + "/" + fileName;

    BlobId blobId = BlobId.of("gamepaper-e336e.appspot.com", path);
    BlobInfo blobInfo = BlobInfo.newBuilder(blobId).setContentType("image/jpeg").build();

    storage.create(blobInfo, fileData);

    return path;
  }

  public List<String> getImageUrls(String game, String type) {
    List<String> urls = new ArrayList<>();
    String prefix = "games/" + game + "/" + type + "/";

    for (Blob blob : storage.list("gamepaper-e336e.appspot.com", Storage.BlobListOption.prefix(prefix)).iterateAll()) {
      urls.add(blob.getMediaLink());
    }

    return urls;
  }
}
