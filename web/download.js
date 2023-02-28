function download() {
    var url = "https://github.com/SongTube/songtube_link_server/releases/download/1.0/installer_windows.exe";
    chrome.tabs.create({ url: url });
}