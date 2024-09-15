import 'package:presentation/metanext_export.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:presentation/widgets/error_box/empty_state_widget.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../metanext1_old/lib/route.dart';
import '../../../../metanext1_old/lib/widgets/home/story_widget/story_page.dart';
import '../../../../metanext1_old/lib/widgets/loading/loading.dart';

Future notificationHandler(BuildContext context,
    {required NotifyType type, required dynamic data}) async {
  if (type.needLogin) {
    _gotoPage(type, data);

    // checkLoginWidget(
    //   context,
    //   action: () => _gotoPage(type, data),
    // );
  } else {
    _gotoPage(type, data);
  }
}

Future _gotoPage(NotifyType type, dynamic data) async {
  switch (type) {
    case NotifyType.new_message:
      // await Get.toNamed(Routes.messageListPage,
      //     arguments: [data, Get.find<RoomController>().streamme]);

      break;
    case NotifyType.order:
      await Get.toNamed(Routes.orderDetailPage, arguments: data);
      break;
    case NotifyType.company_message:
      await Get.toNamed(Routes.orderDetailPage, arguments: data);
      break;
    case NotifyType.story:
      await Get.to(() => StoryHomePage(
            index: 0,
            stroies: data,
          ));
      break;
    case NotifyType.external_url:
      await launchUrl(data, mode: LaunchMode.externalApplication);
      break;
    case NotifyType.internal_url:
      // await Get.to(() => WebViewPage(initUrl: data));
      null;
      break;
    case NotifyType.filtered_products:
      //   await Get.toNamed(Routes.filteredProductsPage, arguments: data);
      // var tempUrl =
      //     'https://api.karakco.ir/api/v1/product?is_brand=0&sort=newest&filter%5Bcategory%5D=2&filter%5Battribute%5D=10%2C11%2C43%2C13%2C14%2C12&filter%5Bbrand%5D=1%2C4&filter%5Bprice%5D=0%2C88800';
      // data = tempUrl;
      var res = await Get.to(
        () => _LoaderPage(
          futuer: () async {
            //call api and go to products fiterss
            BaseResponse<PaginateList<ProductRP>> res =
                await ProductUsecase.instance.productsByUrl(url: data);
            if ((res).hasData) {
              FilterProductsRequestParam filter = FilterProductsRequestParam.fromUrl(res, data);
              PaginateRequestParam paginaterParam =
                  PaginateRequestParam.formUrl(response: res, uri: Uri.parse(data));

              int indexSort = res.sort.indexWhere((element) => element.key == paginaterParam.sort);

              Get.offAndToNamed(Routes.filteredProductsPage, arguments: {
                'is_brand': BaseResponsePageType.brand == res.pageType,
                'selectedFilters': filter,
                'sort': indexSort >= 0 ? res.sort[indexSort] : null,
              });
            } else {
              Get.back();
            }
          },
        ),
        duration: Duration.zero,
      );

      break;
    case NotifyType.invite_in_room:
      // if (Get.isRegistered<RoomController>()) {
      //   Get.find<RoomController>().goToMessagesPage(data);
      // }
      break;
    case NotifyType.pin_message:
      break;
  }
}

class _LoaderPage extends StatefulWidget {
  final Future Function() futuer;
  const _LoaderPage({required this.futuer});

  @override
  State<_LoaderPage> createState() => __LoaderPageState();
}

class __LoaderPageState extends State<_LoaderPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: FutureBuilder(
            future: widget.futuer.call(),
            builder: (context, AsyncSnapshot snap) {
              if (snap.hasData) {
                // if (!snap.data!.isSuccess) {
                //   return ErrorBox(
                //     onTap: () => setState(() {}),
                //   );
                // }
              } else if (snap.hasError) {
                return AppEmptyBox(
                  onPress: () async {
                    setState(() {});
                  },
                );
              }
              return const LoadingWidget();
            }),
      ),
    );
  }
}
