import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:seekfighter/constants/constants.dart';

class PhotoWidget extends StatelessWidget {
  final String photoLink;
  final String searchfor;

  const PhotoWidget({this.photoLink,this.searchfor});

  @override
  Widget build(BuildContext context) {
    return ExtendedImage.network(
      photoLink!=''?photoLink:searchfor=="Player"?'https://www.nicepng.com/png/full/110-1109561_boxing-vector-player-rocky-mobile-game.png':
      searchfor=='Trainer'?'https://cdn2.vectorstock.com/i/thumb-large/39/66/professional-fitness-coach-or-instructor-vector-18353966.jpg'
          :searchfor=='Arbitre'?'https://image.shutterstock.com/image-vector/boxing-match-referee-flat-vector-600w-1477393502.jpg'
      :'',
      fit: BoxFit.cover,
      cache: true,
      enableSlideOutPage: true,
      filterQuality: FilterQuality.high,
      loadStateChanged: (ExtendedImageState state) {
        switch (state.extendedImageLoadState) {
          case LoadState.loading:
            return Center(
              child: SpinKitRing(
                color: kPrimaryColor,
                size: 20,
                lineWidth: 1,
              ),
            );
            break;
          case LoadState.completed:
            return null;
            break;
          case LoadState.failed:
            return GestureDetector(
              child: Center(
                child: Text("Reload"),
              ),
              onTap: () {
                state.reLoadImage();
              },
            );
            break;
        }
        return Text("");
      },
    );
  }
}
