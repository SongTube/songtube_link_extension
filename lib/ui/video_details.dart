import 'package:flutter/material.dart';
import 'package:songtube_link_flutter/internal/app_connection.dart';
import 'package:songtube_link_flutter/internal/models/video.dart';
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
            height: 120,
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
                Text(video.name, style: subtitleTextStyle(context, bold: true), maxLines: 2),
                Text(video.author, style: subtitleTextStyle(context, opacity: 0.6)),
                const SizedBox(height: 8),
                Row(
                  children: [
                    // Download on Device
                    _button(title: 'View', onTap: () async {
                      final status = await AppConnection.sendLink(widget.link!, isDownload: false);
                      if (status) {
                        setState(() {
                          linkSent = true;
                        });
                      }
                      print(status);
                    }),
                    const SizedBox(width: 8),
                    // View on Device
                    _button(title: 'Download', onTap: () async {
                      final status = await AppConnection.sendLink(widget.link!, isDownload: true);
                      if (status) {
                        setState(() {
                          linkSent = true;
                        });
                      }
                      print(status);
                    }),
                    const SizedBox(width: 8),
                    AnimatedSwitcher(
                      duration: const Duration(milliseconds: 200),
                      child: linkSent
                        ? const Icon(Icons.check, color: appColor)
                        : const SizedBox(),
                    )
                  ],
                )
              ],
            ),
          )
        ],
      ) : const SizedBox(width: 24, height: 24, child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation(appColor))),
    );
  }

  Widget _noContent() {
    return Text('No content detected. Go into a\nvideo/playlist and open this extension again', style: textStyle(context, opacity: 0.6), textAlign: TextAlign.center,);
  }

  Widget _button({required String title, required Function() onTap}) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.only(left: 12, right: 12, top: 6, bottom: 6),
        decoration: BoxDecoration(
          color: appColor,
          borderRadius: BorderRadius.circular(5),
          boxShadow: [
            BoxShadow(
              blurRadius: 8,
              color: Colors.black.withOpacity(0.1),
              spreadRadius: 1
            )
          ]
        ),
        child: Text(title, style: subtitleTextStyle(context).copyWith(color: Colors.white)),
      ),
    );
  }

}