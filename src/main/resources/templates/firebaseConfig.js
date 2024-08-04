import { initializeApp } from "firebase/app";
import { getAnalytics } from "firebase/analytics";
import { getStorage, ref, getDownloadURL } from "firebase/storage";

// Your web app's Firebase configuration
const firebaseConfig = {
  apiKey: "AIzaSyBU5dsNHDr_9Ivt09lGxIGKg1iFRSHsEPI",
  authDomain: "gamepaper-e336e.firebaseapp.com",
  projectId: "gamepaper-e336e",
  storageBucket: "gamepaper-e336e.appspot.com",
  messagingSenderId: "553305162921",
  appId: "1:553305162921:web:59a1b2d2b84597173855b8",
  measurementId: "G-X8VQZS4XJ6",
};

// Initialize Firebase
const app = initializeApp(firebaseConfig);
const analytics = getAnalytics(app);
const storage = getStorage(app);

export { storage, ref, getDownloadURL };
