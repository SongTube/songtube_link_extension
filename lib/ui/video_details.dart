import 'package:flutter/material.dart';
import 'package:songtube_link_flutter/internal/app_connection.dart';
import 'package:songtube_link_flutter/internal/models/video.dart';
import 'package:songtube_link_flutter/internal/shared_preferences.dart';
import 'package:songtube_link_flutter/internal/styles.dart';
import 'package:songtube_link_flutter/internal/utils.dart';

class VideoDetails extends StatefulWidget {
  const VideoDetails({
    required this.link,
    super.key});
  final String? link;

  @override
  State<VideoDetails> createState() => _VideoDetailsState();
}

class _VideoDetailsState extends State<VideoDetails> {

  // Link Sent to device
  bool linkSent = false;

  Future<Video?> fetchDetails() async {
    return await Video.fromUrl(widget.link!);
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 300),
      child: Utils.parsePlaylistId(widget.link) != null || Utils.parseVideoId(widget.link) != null
        ? FutureBuilder<Video?>(
            future: fetchDetails(),
            builder: (context, snapshot) {
              return _videoDetails(snapshot.data);
            }
          )
        : _noContent()
    );
  }

  Widget _videoDetails(Video? video) {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 200),
      child: video != null ? Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            height: 130,
            child: AspectRatio(
              aspectRatio: 16/9,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(5),
                child: Image.network(
                  Utils.fetchVideoThumbnail(widget.link!),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(video.name, style: subtitleTextStyle(context, bold: true), maxLines: 1),
                Text(video.author, style: subtitleTextStyle(context, opacity: 0.6), maxLines: 1),
                const SizedBox(height: 8),
                Row(
                  children: [
                    // View on Device
                    VideoDetailsButton(title: 'View', onTap: () async {
                      final status = await AppConnection.sendLink(widget.link!, isDownload: false);
                      if (status) {
                        setState(() {
                          linkSent = true;
                        });
                      }
                    }),
                    const SizedBox(width: 8),
                    // Instantly Download on Device
                    VideoDetailsButton(title: 'Instant Download', onTap: () async {
                      final status = await AppConnection.sendLink(widget.link!, isDownload: true);
                      if (status) {
                        setState(() {
                          linkSent = true;
                        });
                      }
                    }),
                    const SizedBox(width: 8),
                    if (false)
                    DropdownButton<String>(
                      value: prefs.getString('instant_download_format') ?? 'AAC',
                      iconSize: 18,
                      borderRadius: BorderRadius.circular(5),
                      iconEnabledColor: appColor,
                      style: TextStyle(
                        color: Colors.black.withOpacity(0.6),
                        fontFamily: 'Product Sans',
                        fontWeight: FontWeight.w600,
                        fontSize: 12
                      ),
                      underline: Container(),
                      items: const [
                        DropdownMenuItem(
                          value: "AAC",
                          child: Text("AAC"),
                        ),
                        DropdownMenuItem(
                          value: "OGG",
                          child: Text("OGG"),
                        )
                      ],
                      onChanged: (String? value) async {
                        if (value == "AAC") {
                          await prefs.setString('instant_download_format', 'AAC');
                          setState(() {});
                        } else if (value == "OGG") {
                          await prefs.setString('instant_download_format', 'OGG');
                          setState(() {});
                        }
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text('View or Download in the SongTube App\nDownload is audio only', style: tinyTextStyle(context, opacity: 0.6))
              ],
            ),
          )
        ],
      ) : const SizedBox(width: 24, height: 24, child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation(appColor))),
    );
  }

  Widget _noContent() {
    return Text('No content detected\nOpen a Video or Playlist and check again', style: textStyle(context, opacity: 0.6, bold: false), textAlign: TextAlign.center,);
  }

}

class VideoDetailsButton extends StatefulWidget {
  const VideoDetailsButton({
    required this.title,
    required this.onTap,
    super.key});
  final String title;
  final Function() onTap;
  @override
  State<VideoDetailsButton> createState() => _VideoDetailsButtonState();
}

class _VideoDetailsButtonState extends State<VideoDetailsButton> {

  // Pressed status
  bool pressed = false;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: pressed ? () {} : () {
        setState(() {
          pressed = true;
        });
        widget.onTap();
        Future.delayed(const Duration(seconds: 5), () {
          setState(() {
            pressed = false;
          });
        });
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        padding: const EdgeInsets.only(left: 12, right: 12, top: 6, bottom: 6),
        decoration: BoxDecoration(
          color: pressed ? Colors.grey : appColor,
          borderRadius: BorderRadius.circular(5),
          boxShadow: [
            BoxShadow(
              blurRadius: 8,
              color: Colors.black.withOpacity(0.1),
              spreadRadius: 1
            )
          ]
        ),
        child: Text(widget.title, style: subtitleTextStyle(context).copyWith(color: Colors.white)),
      ),
    );
  }
}