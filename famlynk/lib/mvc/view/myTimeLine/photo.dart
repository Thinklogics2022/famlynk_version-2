import 'package:famlynk/mvc/model/newsfeed_model/newsFeed_model.dart';
import 'package:flutter/material.dart';
import 'package:famlynk/services/profileService/myTimeLine/myTimeLine_service.dart';
import 'package:cached_network_image/cached_network_image.dart';

class PhotoPage extends StatefulWidget {
  @override
  _PhotoPageState createState() => _PhotoPageState();
}

class _PhotoPageState extends State<PhotoPage> {
  List<NewsFeedModel> mediaList = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchMedia();
  }

  Future<void> _fetchMedia() async {
    try {
      final service = MyTimeLineService();
      mediaList = await service.getMyTimeLine();
      mediaList.sort((a, b) {
        final aDate = a.createdOn;
        final bDate = b.createdOn;
        return bDate.compareTo(aDate);
      });
      mediaList = mediaList.reversed.toList();
      setState(() {
        isLoading = false;
      });
    } catch (e) {
      print('Failed to fetch media: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final nonEmptyMediaList =
        mediaList.where((media) => media.photo != null && media.photo!.isNotEmpty).toList();
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 223, 228, 237),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : (nonEmptyMediaList.isEmpty
              ? Center(child: Text('No media available.'))
              : _buildMediaGridView(nonEmptyMediaList)),
    );
  }

  Widget _buildMediaGridView(List<NewsFeedModel> mediaList) {
    final padding = EdgeInsets.symmetric(
      horizontal: MediaQuery.of(context).size.width * 0.01,
      vertical: MediaQuery.of(context).size.width * 0.01,
    );

    return GridView.builder(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
      ),
      itemCount: mediaList.length,
      itemBuilder: (context, index) {
        return Padding(
          padding: padding,
          child: _buildImage(mediaList[index]),
        );
      },
    );
  }

  Widget _buildImage(NewsFeedModel media) {
    return CachedNetworkImage(
      imageUrl: media.photo!,
      fit: BoxFit.cover,
      placeholder: (context, url) => CircularProgressIndicator(),
      errorWidget: (context, url, error) => Icon(Icons.error),
    );
  }
}