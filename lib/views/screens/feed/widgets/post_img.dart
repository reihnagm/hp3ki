import 'dart:io';

import 'package:external_path/external_path.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shimmer/shimmer.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter_animated_dialog/flutter_animated_dialog.dart';

import 'package:hp3ki/services/navigation.dart';

import 'package:hp3ki/views/basewidgets/preview/preview.dart';
import 'package:hp3ki/views/basewidgets/snackbar/snackbar.dart';

import 'package:hp3ki/utils/color_resources.dart';
import 'package:hp3ki/utils/custom_themes.dart';
import 'package:hp3ki/utils/dimensions.dart';

class PostImage extends StatefulWidget {
  final bool isDetail;
  final List medias;

  const PostImage(
    this.isDetail,
    this.medias,
    {Key? key}
  ) : super(key: key);

  @override
  PostImageState createState() => PostImageState();
}

class PostImageState extends State<PostImage> {
  int current = 0;

  @override
  Widget build(BuildContext context) {
    
    if(widget.medias.length > 3 && !widget.isDetail) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          
          const SizedBox(height: 8.0),

          Row(
            mainAxisSize: MainAxisSize.max,
            children: [
              Expanded(
                child: CachedNetworkImage(
                  imageUrl: "${widget.medias.first.path}",
                  imageBuilder: (BuildContext context, ImageProvider<Object> imageProvider) => Container(
                    height: 200.0,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: imageProvider,
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                  errorWidget: (BuildContext context, String url, dynamic _) {
                    return Container(
                      margin: const EdgeInsets.all(0.0),
                      padding: const EdgeInsets.all(0.0),
                      width: double.infinity,
                      height: 200.0,
                      decoration: const BoxDecoration(
                        image: DecorationImage(
                          fit: BoxFit.contain,
                          image: AssetImage("assets/images/logo/logo.png")
                        )
                      ),
                    );
                  },
                  placeholder: (BuildContext context, String url) {
                    return Shimmer.fromColors(
                      highlightColor: ColorResources.white,
                      baseColor: Colors.grey[200]!,
                      child: Container(
                        margin: const EdgeInsets.all(0.0),
                        padding: const EdgeInsets.all(0.0),
                        width: double.infinity,
                        height: 200.0,
                        color: ColorResources.white
                      )  
                    );
                  } 
                ),
              ),
              Expanded(
                child:  Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Stack(
                      clipBehavior: Clip.none,
                      children: [

                        CachedNetworkImage(
                          imageUrl: "${widget.medias[1].path}",
                          imageBuilder: (BuildContext context, ImageProvider<Object> imageProvider) => Container(
                            height: 200.0,
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                image: imageProvider,
                                fit: BoxFit.contain,
                              ),
                            ),
                          ),
                          errorWidget: (BuildContext context, String url, dynamic _) {
                            return Container(
                              margin: const EdgeInsets.all(0.0),
                              padding: const EdgeInsets.all(0.0),
                              width: double.infinity,
                              height: 200.0,
                              decoration: const BoxDecoration(
                                image: DecorationImage(
                                  fit: BoxFit.contain,
                                  image: AssetImage("assets/images/logo/logo.png")
                                )
                              ),
                            );
                          },
                          placeholder: (BuildContext context, String url) {
                            return Shimmer.fromColors(
                              highlightColor: ColorResources.white,
                              baseColor: Colors.grey[200]!,
                              child: Container(
                                margin: const EdgeInsets.all(0.0),
                                padding: const EdgeInsets.all(0.0),
                                width: double.infinity,
                                height: 200.0,
                                color: ColorResources.white
                              )  
                            );
                          } 
                        ),

                        Positioned(
                          top: 0.0,
                          left: 0.0,
                          right: 0.0,
                          bottom: 0.0,
                          child: Container(
                            width: double.infinity,
                            alignment: Alignment.center,
                            height: 200.0,
                            decoration:  BoxDecoration(
                              color: ColorResources.black.withOpacity(0.6)
                            ),
                            child: Text("Photos (+${widget.medias.length - 3})",
                              style: robotoRegular.copyWith(
                                color: ColorResources.white,
                                fontSize: Dimensions.fontSizeDefault,
                                fontWeight: FontWeight.w600,
                              ),
                            )
                          )
                        ),

                      ],
                    ),
                    CachedNetworkImage(
                      imageUrl: "${widget.medias[2].path}",
                      imageBuilder: (BuildContext context, ImageProvider<Object> imageProvider) => Container(
                        height: 200.0,
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: imageProvider,
                            fit: BoxFit.contain,
                          ),
                        ),
                      ),
                      errorWidget: (BuildContext context, String url, dynamic _) {
                        return Container(
                          margin: const EdgeInsets.all(0.0),
                          padding: const EdgeInsets.all(0.0),
                          width: double.infinity,
                          height: 200.0,
                          decoration: const BoxDecoration(
                            image: DecorationImage(
                              fit: BoxFit.contain,
                              image: AssetImage("assets/images/logo/logo.png")
                            )
                          ),
                        );
                      },
                      placeholder: (BuildContext context, String url) {
                        return Shimmer.fromColors(
                          highlightColor: ColorResources.white,
                          baseColor: Colors.grey[200]!,
                          child: Container(
                            margin: const EdgeInsets.all(0.0),
                            padding: const EdgeInsets.all(0.0),
                            width: double.infinity,
                            height: 200.0,
                            color: ColorResources.white
                          )  
                        );
                      } 
                    ),
                  ],
                ) 
              )
            ],
          )
        ]
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        
        const SizedBox(height: 8.0),

        CarouselSlider(
          options: CarouselOptions(
            height: 200.0,
            enableInfiniteScroll: false,
            viewportFraction: 1.0,
            onPageChanged: (int i, CarouselPageChangedReason reason) {
              setState(() => current = i);
            }
          ),
          items: widget.medias.map((i) {
            return InkWell(
              onTap: () {
                NS.push(context, PreviewImageScreen(
                  id: current,
                  medias: widget.medias,
                ));
              },
              onLongPress: () async {
                showAnimatedDialog(
                  context: context,
                  barrierDismissible: true,
                  builder: (ctx) {
                    return Dialog(
                      child: Container(
                      height: 50.0,
                      padding: const EdgeInsets.all(10.0),
                      margin: const EdgeInsets.only(top: 10.0, bottom: 10.0, left: 16.0, right: 16.0),
                      child: StatefulBuilder(
                        builder: (BuildContext c, Function s) {
                        return ElevatedButton(
                          onPressed: () async { 
                            Directory documentsIos = await getApplicationDocumentsDirectory();
                            String? saveDir = Platform.isIOS 
                            ? documentsIos.path 
                            : await ExternalPath.getExternalStoragePublicDirectory(ExternalPath.DIRECTORY_DOWNLOADS);
                            NS.pop(context);
                            ShowSnackbar.snackbar(context, "Gambar telah disimpan pada $saveDir", "", ColorResources.success);
                          },
                          child: Text("Unduh Gambar", 
                            style: robotoRegular.copyWith(
                              fontSize: Dimensions.fontSizeDefault
                            ),
                          ),                           
                        );
                      })
                      )
                    );
                  },
                );
              },
              child: CachedNetworkImage(
                imageUrl: "${i.path}",
                imageBuilder: (BuildContext context, ImageProvider<Object> imageProvider) => Container(
                  height: 200.0,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: imageProvider,
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
                errorWidget: (BuildContext context, String url, dynamic _) {
                  return Container(
                    margin: const EdgeInsets.all(0.0),
                    padding: const EdgeInsets.all(0.0),
                    width: double.infinity,
                    height: 200.0,
                    decoration: const BoxDecoration(
                      image: DecorationImage(
                        fit: BoxFit.contain,
                        image: AssetImage("assets/images/logo/logo.png")
                      )
                    ),
                  );
                },
                placeholder: (BuildContext context, String url) {
                  return Shimmer.fromColors(
                    highlightColor: ColorResources.white,
                    baseColor: Colors.grey[200]!,
                    child: Container(
                      margin: const EdgeInsets.all(0.0),
                      padding: const EdgeInsets.all(0.0),
                      width: double.infinity,
                      height: 200.0,
                      color: ColorResources.white
                    )  
                  );
                } 
              ),
            );
          }).toList(),
        ),
        
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: widget.medias.map((i) {
            int index = widget.medias.indexOf(i);
            return Container(
              width: 8.0,
              height: 8.0,
              margin: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 2.0),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: current == index
                  ? ColorResources.primary
                  : ColorResources.dimGrey,
              ),
            );
          }).toList(),
        ),

      ],
    );
  }
}