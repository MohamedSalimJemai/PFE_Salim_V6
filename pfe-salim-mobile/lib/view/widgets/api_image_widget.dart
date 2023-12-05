import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:pfe_salim/utils/dimensions.dart';
import 'package:pfe_salim/utils/token_manager.dart';

import '../../../env.dart';
import '../../../utils/language/localization.dart';
import '../../../utils/theme/theme_styles.dart';

class ApiImageWidget extends StatelessWidget {
  final String? imagePath;
  final double? height;
  final double? width;
  final BoxFit? boxFit;
  final bool isProfilePicture;

  const ApiImageWidget({
    super.key,
    this.imagePath,
    this.height,
    this.width,
    this.boxFit,
    this.isProfilePicture = false,
  });

  // --------------------------- BUILD METHODS -----------------------------  //

  @override
  Widget build(BuildContext context) {
    return imagePath != null
        ? CachedNetworkImage(
            key: Key(imagePath!),
            height: height,
            width: width,
            cacheKey: imagePath,
            imageUrl: "$imagesUrl/$imagePath",
            httpHeaders: {
              "Authorization": "Bearer ${(TokenManager.storedToken)}"
            },
            imageBuilder: (context, imageProvider) {
              return isProfilePicture
                  ? CircleAvatar(backgroundImage: imageProvider)
                  : Container(
                      color: darkColor,
                      child: Image(
                        image: imageProvider,
                        fit: boxFit,
                      ),
                    );
            },
            progressIndicatorBuilder: (context, url, progress) {
              return Center(
                child: SpinKitFadingCircle(
                  color: Styles.primaryColor,
                  size: 50.0,
                ),
              );
            },
            errorWidget: (context, url, error) {
              return _buildErrorWidget(
                height: height,
                width: width,
                isCircular: isProfilePicture,
              );
            },
          )
        : _buildNoImageWidget(
            height: height,
            width: width,
            isCircular: isProfilePicture,
          );
  }

  static Widget _buildErrorWidget({
    double? height,
    double? width,
    bool isCircular = false,
  }) {
    return SizedBox(
      height: height,
      width: width,
      child: isCircular
          ? CircleAvatar(
              backgroundColor: Styles.primaryColor.withOpacity(0.75),
              child: Icon(Icons.person, size: (height ?? 80) / 2),
            )
          : Container(
              decoration: BoxDecoration(
                color: darkColor.withOpacity(0.6),
                borderRadius: Dimensions.roundedBorderMedium,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.broken_image_outlined,
                    color: lightColor,
                    size: 60,
                  ),
                  Text(
                    intl.couldntLoadImage,
                    style: const TextStyle(color: lightColor),
                  )
                ],
              ),
            ),
    );
  }

  static Widget _buildNoImageWidget({
    double? height,
    double? width,
    bool isCircular = false,
  }) {
    return SizedBox(
      height: height,
      width: width,
      child: isCircular
          ? CircleAvatar(
              backgroundColor: Styles.primaryColor.withOpacity(0.75),
              child: Icon(Icons.person, size: (height ?? 80) / 2),
            )
          : Container(
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.5),
                borderRadius: Dimensions.roundedBorderMedium,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.image_outlined,
                    color: lightColor,
                    size: 60,
                  ),
                  Text(
                    intl.noImage,
                    style: const TextStyle(color: lightColor),
                  )
                ],
              ),
            ),
    );
  }
}
