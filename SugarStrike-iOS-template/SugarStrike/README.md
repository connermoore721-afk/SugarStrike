# Sugar Strike: build an iPhone .ipa with no Xcode

GitHub's free cloud Macs build the app for you. Then a free tool on your Windows PC or Mac installs it on the iPhone.

## Part 1: Get the .ipa (about 10 minutes, all in a web browser)

1. Make a free account at **github.com** if you don't have one.
2. Click **+ → New repository**. Name it `sugar-strike`, choose **Public** (Mac build time is free for public repos), and click **Create repository**.
3. On the new repo page, click **uploading an existing file**. Drag in **everything inside** this folder: `SugarStrike.xcodeproj`, the `SugarStrike` folder, and `README.md`. Click **Commit changes**.
4. Add the build recipe. Your computer may hide the `.github` folder, so it's easiest to create it by hand:
   - Click **Add file → Create new file**.
   - In the name box, type exactly: `.github/workflows/build-ipa.yml`
   - Open `.github/workflows/build-ipa.yml` from this zip (or copy the text out of `build-ipa.yml.txt`), and paste it all into the editor.
   - Click **Commit changes**.
5. Open the **Actions** tab. A build named *Build Sugar Strike IPA* starts by itself and takes about 3–5 minutes. A green ✓ means it worked.
6. Open the repo's **Releases** section on the right side of the main page and download **SugarStrike.ipa**.

To rebuild any time: **Actions → Build Sugar Strike IPA → Run workflow**. Any change you commit to `SugarStrike/game.html` also rebuilds it automatically.

## Part 2: Put it on the iPhone (Sideloadly, free)

1. Install **Sideloadly** (sideloadly.io) on a Windows PC or Mac. On Windows, also install **iTunes** and **iCloud** from Apple's website, *not* the Microsoft Store versions.
2. Plug the iPhone in with a cable, unlock it, and tap **Trust** if the phone asks.
3. Open Sideloadly and drag `SugarStrike.ipa` into it. Type your **Apple ID** email and click **Start**. Sign in when asked. A spare Apple ID works fine.
4. On the iPhone:
   - Go to **Settings → General → VPN & Device Management**, tap your Apple ID, and tap **Trust**.
   - If iOS asks, also turn on **Settings → Privacy & Security → Developer Mode** and restart.
5. Tap the **Sugar Strike** icon and play.

**Good to know**
- With a free Apple ID, the app stops opening after **7 days**. Plug the phone in and run Sideloadly again with the same .ipa. Saved progress stays.
- A free Apple ID can have up to 3 sideloaded apps at once.
- **AltStore** (altstore.io) is another free option. It can refresh the app over Wi-Fi so you don't have to plug in every week.

## If the build fails
Open the failed run in the **Actions** tab and click the red step to see the error. Usually a file was uploaded into the wrong folder. The repo's main page should show `SugarStrike.xcodeproj`, `SugarStrike/` and `.github/` side by side, not inside another folder.
