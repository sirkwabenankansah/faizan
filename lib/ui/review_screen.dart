import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_kundol/blocs/reviews/reviews_bloc.dart';
import 'package:flutter_kundol/constants/app_styles.dart';
import 'package:flutter_kundol/repos/reviews_repo.dart';

import '../tweaks/app_localization.dart';
import 'detail_screen.dart';
final SnackBar _snackBar = SnackBar(
  content: const Text('Add Review Sucsessfully'),
  duration: const Duration(seconds: 5),
);
class ReviewScreen extends StatefulWidget {
  final int productId;
  const ReviewScreen(this.productId);

  @override
  _ReviewState createState() => _ReviewState();
}

class _ReviewState extends State<ReviewScreen> {
  @override
  void initState() {
    super.initState();
    BlocProvider.of<ReviewsBloc>(context).add(const GetReviews(1));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Theme.of(context).brightness == Brightness.dark ? Theme.of(context).scaffoldBackgroundColor :  Colors.white,

        appBar: AppBar(
          centerTitle: true,
          iconTheme: Theme.of(context).iconTheme,
          backgroundColor: Theme.of(context).cardColor,
          title: Text(
              AppLocalizations.of(context)!.translate("Review")!,
              style: Theme.of(context).textTheme.headline6),
          elevation: 0.0,
        ),
        body: BlocBuilder<ReviewsBloc, ReviewsState>(
          builder: (context, state) {
            if (state is ReviewsLoaded) {
              return Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20,vertical: 20),
                    child: Row(
                      children: [
                        SizedBox(
                          width: 130,
                          height: 130,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: const [
                                  Text("3.00",style: TextStyle(fontSize: 18),),
                                  SizedBox(width: 4,),
                                  Icon(Icons.star,size: 22,),
                                ],
                              ),
                              Text(
                                AppLocalizations.of(context)!.translate("rating")!,
                                style: TextStyle(fontSize: 18,color: Theme.of(context).primaryColor),),
                            ],
                          ),
                        ),
                        Container(
                          width: 1,
                          height: 110,
                          color: Colors.grey,
                        ),
                        Expanded(
                          child: SizedBox(
                            height: 130,
                            width: double.maxFinite,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Row(
                                  children: [
                                    SizedBox(width: 8,),
                                    Text("1"),
                                    Icon(Icons.star,size: 16,),
                                    SizedBox(width: 4,),
                                    Expanded(
                                      child:LinearProgressIndicator(
                                        minHeight: 7,
                                        valueColor: AlwaysStoppedAnimation<Color>(Colors.amber,),
                                        backgroundColor: Theme.of(context).brightness == Brightness.dark ? Theme.of(context).primaryColorLight : Theme.of(context).primaryColor,
                                        value: 0.1,
                                      ),
                                    ),
                                    SizedBox(width: 4,),

                                  ],
                                ),

                                const SizedBox(height: 4,),
                                Row(
                                  children: [
                                    SizedBox(width: 8,),
                                    Text("2"),
                                    Icon(Icons.star,size: 16,),
                                    SizedBox(width: 4,),
                                    Expanded(
                                      child:LinearProgressIndicator(
                                        minHeight: 7,
                                        valueColor: AlwaysStoppedAnimation<Color>(Colors.amber,),
                                        backgroundColor: Theme.of(context).brightness == Brightness.dark ? Theme.of(context).primaryColorLight : Theme.of(context).primaryColor,
                                        value: 0.2,
                                      ),
                                    ),
                                    SizedBox(width: 4,),

                                  ],
                                ),
                                const SizedBox(height: 4,),
                                Row(
                                  children: [
                                    SizedBox(width: 8,),
                                    Text("3"),
                                    Icon(Icons.star,size: 16,),
                                    SizedBox(width: 4,),
                                    Expanded(
                                      child:LinearProgressIndicator(
                                        minHeight: 7,
                                        valueColor: AlwaysStoppedAnimation<Color>(Colors.amber,),
                                        backgroundColor: Theme.of(context).brightness == Brightness.dark ? Theme.of(context).primaryColorLight : Theme.of(context).primaryColor,
                                        value: 0.3,
                                      ),
                                    ),
                                    SizedBox(width: 4,),

                                  ],
                                ),
                                const SizedBox(height: 4,),
                                Row(
                                  children: [
                                    SizedBox(width: 8,),
                                    Text("4"),
                                    Icon(Icons.star,size: 16,),
                                    SizedBox(width: 4,),
                                    Expanded(
                                      child:LinearProgressIndicator(
                                        minHeight: 7,
                                        valueColor: AlwaysStoppedAnimation<Color>(Colors.amber,),
                                        backgroundColor: Theme.of(context).brightness == Brightness.dark ? Theme.of(context).primaryColorLight : Theme.of(context).primaryColor,
                                        value: 0.4,
                                      ),
                                    ),
                                    SizedBox(width: 4,),

                                  ],
                                ),
                                const SizedBox(height: 4,),
                                Row(
                                  children: [
                                    SizedBox(width: 8,),
                                    Text("5"),
                                    Icon(Icons.star,size: 16,),
                                    SizedBox(width: 4,),
                                    Expanded(
                                      child:LinearProgressIndicator(
                                        minHeight: 7,
                                        valueColor: AlwaysStoppedAnimation<Color>(Colors.amber,),
                                        backgroundColor: Theme.of(context).brightness == Brightness.dark ? Theme.of(context).primaryColorLight : Theme.of(context).primaryColor,
                                        value: 0.5,
                                      ),
                                    ),
                                    SizedBox(width: 4,),

                                  ],
                                ),
                                const SizedBox(height: 4,),

                              ],
                            ),
                          ),
                        )

                      ],
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.symmetric(
                        horizontal: AppStyles.SCREEN_MARGIN_HORIZONTAL),
                    height: 45.0,
                    width: double.maxFinite,
                    child: ElevatedButton(
                        style: ButtonStyle(
                            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(40.0),

                                )
                            )
                        ),
                        onPressed: () {
                          showReviewDialog();
                        },
                        child: Text(
                            AppLocalizations.of(context)!.translate("Write a Review")!
                        )),
                  ),

                  const SizedBox(height: 10,),
                  Expanded(
                    child: (state.reviewsData.isEmpty) ?  Container(child: Center(child: Text(
                        AppLocalizations.of(context)!.translate("Empty")!
                    ),),) : ListView.builder(
                    shrinkWrap: true,
                      itemCount: state.reviewsData.length,
                      itemBuilder: (context, index) =>
                      //     ListTile(
                      //   title: Text(state
                      //           .reviewsData[index].customer.customerFirstName +
                      //       " " +
                      //       state.reviewsData[index].customer.customerLastName),
                      //   subtitle: Text(state.reviewsData[index].comment),
                      //   leading: Container(
                      //     width: 50.0,
                      //     height: 50.0,
                      //     decoration: new BoxDecoration(shape: BoxShape.circle),
                      //     child: ClipRRect(
                      //       borderRadius: BorderRadius.circular(50.0),
                      //       child: CachedNetworkImage(
                      //         imageUrl:
                      //             "https://i.pinimg.com/originals/7c/c7/a6/7cc7a630624d20f7797cb4c8e93c09c1.png",
                      //         fit: BoxFit.fill,
                      //         progressIndicatorBuilder:
                      //             (context, url, downloadProgress) =>
                      //                 CircularProgressIndicator(
                      //                     value: downloadProgress.progress),
                      //         errorWidget: (context, url, error) =>
                      //             Icon(Icons.error),
                      //       ),
                      //     ),
                      //   ),
                      //   trailing: StarRating(
                      //       starCount: 5,
                      //       rating: double.parse(state.reviewsData[index].rating),
                      //       onRatingChanged: (rating) {}),
                      // ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 14,vertical: 10),
                        color: Theme.of(context).brightness == Brightness.dark ? Theme.of(context).cardColor :  Colors.white,
                        child: Row(
                          children: [
                            Container(
                              width: 50.0,
                              height: 50.0,
                              decoration: const BoxDecoration(shape: BoxShape.circle),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(50.0),
                                child: CachedNetworkImage(
                                  imageUrl:
                                  "https://i.pinimg.com/originals/7c/c7/a6/7cc7a630624d20f7797cb4c8e93c09c1.png",
                                  fit: BoxFit.fill,
                                  progressIndicatorBuilder:
                                      (context, url, downloadProgress) =>
                                      CircularProgressIndicator(
                                          backgroundColor: Theme.of(context).brightness == Brightness.dark ? Theme.of(context).primaryColorLight : Theme.of(context).primaryColor,
                                          value: downloadProgress.progress),
                                  errorWidget: (context, url, error) =>
                                      const Icon(Icons.error),
                                ),
                              ),
                            ),
                            const SizedBox(width: 10,),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text("${state.reviewsData[index].customer?.customerFirstName} ${state.reviewsData[index].customer?.customerLastName}"),
                                        Container(
                                          child: StarRating(
                                              starCount: 5,
                                              rating: double.parse(state.reviewsData[index].rating!),
                                              onRatingChanged: (rating) {}, color: Colors.black12,),
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(height: 4,),
                                  Text(state.reviewsData[index].comment!),

                                  const Divider(),
                                ],
                              ),
                            ),

                          ],
                        ),
                      ),
                    ),
                  ),
                  // Container(
                  //   margin: EdgeInsets.symmetric(
                  //       vertical: AppStyles.SCREEN_MARGIN_VERTICAL,
                  //       horizontal: AppStyles.SCREEN_MARGIN_HORIZONTAL),
                  //   height: 45.0,
                  //   width: double.maxFinite,
                  //   child: ElevatedButton(
                  //       onPressed: () {
                  //         showReviewDialog();
                  //       },
                  //       child: Text("Write a Review")),
                  // ),
                ],
              );
            } else {
              return Center(
                child: CircularProgressIndicator(
                  color: Colors.white,
                  backgroundColor: Theme.of(context).brightness == Brightness.dark ? Theme.of(context).primaryColorLight : Theme.of(context).primaryColor,
                ),
              );
            }
          },
        ));
  }

  void showReviewDialog() {
    Dialog ratingDialog = Dialog(
      //this right here
      child: BlocProvider(create: (context) => ReviewsBloc(RealReviewsRepo()),
      child: RatingDialogBody(context: context, productId: widget.productId,)),
    );
    showDialog(
        context: context, builder: (BuildContext context) => ratingDialog);
  }
}

class RatingDialogBody extends StatefulWidget {
  const RatingDialogBody({
    Key? key,
    required this.context,
    required this.productId,
  }) : super(key: key);

  final BuildContext context;
  final int? productId;

  @override
  _RatingDialogBodyState createState() => _RatingDialogBodyState();
}

class _RatingDialogBodyState extends State<RatingDialogBody> {
  double rating=0.0;

  final TextEditingController? _messageController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Padding(
        padding: const EdgeInsets.symmetric(
            vertical: AppStyles.SCREEN_MARGIN_VERTICAL,
            horizontal: AppStyles.SCREEN_MARGIN_HORIZONTAL),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                    AppLocalizations.of(context)!.translate("Your Rating")!
                ),
                StarRating(
                    starCount: 5, rating: rating, onRatingChanged: (rating) {
                      setState(() {
                        this.rating = rating;
                      });
                }, color: Colors.black12,),
              ],
            ),
            const SizedBox(
              height: 6.0,
            ),
            TextField(
              minLines: 5,
              maxLines: null,
              controller: _messageController,
              keyboardType: TextInputType.multiline,
              autofocus: false,
              decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                    borderSide: const BorderSide(
                      width: 0,
                      style: BorderStyle.none,
                    ),
                  ),
                  fillColor: Theme.of(context).brightness == Brightness.dark
                      ? AppStyles.COLOR_LITE_GREY_DARK
                      : AppStyles.COLOR_LITE_GREY_LIGHT,
                  filled: true,
                  // border: InputBorder.none,
                  hintText:
                  AppLocalizations.of(context)!.translate("Your comment")!,
                  hintStyle: TextStyle(
                      color: Theme.of(context).brightness == Brightness.dark
                          ? AppStyles.COLOR_GREY_DARK
                          : AppStyles.COLOR_GREY_LIGHT,
                      fontSize: 14)),
            ),
            const SizedBox(
              height: 6.0,
            ),
            SizedBox(
              height: 45.0,
              width: double.maxFinite,
              child:
                  ElevatedButton(
                      style: ButtonStyle(
                          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                              RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(40.0),
                              )
                          )
                      ),
                      onPressed: () {
                    if(_messageController!.text.isNotEmpty) {
                      BlocProvider.of<ReviewsBloc>(context).add(AddReviews(widget.productId!, _messageController!.text, rating,null));
                      ScaffoldMessenger.of(context).showSnackBar(_snackBar);
                    }
                      }, child: Text(
                      AppLocalizations.of(context)!.translate("Add Review")!
                  )),
            ),
          ],
        ),
      ),
    );
  }
}
