# avdmanager delete avd -n test
# avdmanager create avd -n test -d pixel_3 -k "system-images;android-30;google_apis_playstore;x86"

rm -rf /root/.android/avd/test.avd/*.lock
emulator -avd test -no-window -noaudio -timezone Asia/Kolkata &
# emulator @test -noaudio -timezone Asia/Kolkata &
echo "Waiting 60s for AVD warm up"
sleep 300
echo "Installing APK"
adb install app-debug.apk
adb shell am start -n com.example.socketapp/com.example.socketapp.MainActivity
echo "Finished installing & starting APK steps"
sleep infinity
