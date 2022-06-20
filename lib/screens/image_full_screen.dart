import 'dart:io';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ionicons/ionicons.dart';
import 'package:photo_view/photo_view.dart';

class ImageFullScreen extends StatefulWidget {

  final List<File> imagesFile;
  final int imageSelected;

  const ImageFullScreen({Key? key, required this.imagesFile, required this.imageSelected}) : super(key: key);

  @override
  State<ImageFullScreen> createState() => _ImageFullScreenState();
}

class _ImageFullScreenState extends State<ImageFullScreen> {

  List<File> imagesFile = [];
  int imgNumber = 0;

  @override
  void initState() {
    super.initState();
    imagesFile = widget.imagesFile;
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeRight,
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
  }

  @override
  void dispose() {
    if(mounted){
      SystemChrome.setPreferredOrientations([
        DeviceOrientation.portraitUp,
        DeviceOrientation.portraitDown,
      ]);
    }
    super.dispose();
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Stack(
          children: [
            CarouselSlider.builder(
              options: CarouselOptions(
                height: MediaQuery.of(context).size.height,
                enableInfiniteScroll: false,
                viewportFraction: 1.0,
                enlargeCenterPage: false,
                initialPage: widget.imageSelected,
              ),
              itemCount: widget.imagesFile.length,
              itemBuilder: (BuildContext context, int itemIndex,_) {
            
                final File imageFile = imagesFile[itemIndex];
                
                return Hero(
                  tag: imageFile.path,
                  child: PhotoView(
                    maxScale: PhotoViewComputedScale.covered,
                    minScale: PhotoViewComputedScale.contained,
                    imageProvider: FileImage(imageFile),
                  ),
                );
              },
            ),
            // Hero(
            //   tag: widget.imagesFile,
            //   child: ClipRRect(
            //     borderRadius: BorderRadius.circular(10),
            //     child: PhotoView(
            //       minScale: PhotoViewComputedScale.contained,
            //       maxScale: PhotoViewComputedScale.covered,
            //       imageProvider: FileImage(file),
            //     ),
            //   ),
            // ),
            Positioned(
              right: 5,
              child: GestureDetector(
                onTap: () {
                  HapticFeedback.lightImpact();
                  Navigator.pop(context);
                },
                child: const Icon(Ionicons.close,color: Colors.white,size: 30),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
