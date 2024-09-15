import 'package:presentation/metanext_export.dart';
import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

import '../../../../metanext1_old/lib/widgets/error_box/empty_state_widget.dart';
import '../../../../metanext1_old/lib/widgets/loading/loading.dart';

extension MyPagingControllerExt<TT, T> on PagingController<int, T> {
  Future<BaseResponse<PaginateList<T>>> myFetchResponse({
    required Future<BaseResponse<PaginateList<T>>> api,
    required int nextPage,
  }) async {
    var res = await api;

    await fetchResponse(
      list: res.data?.list ?? [],
      isFirst: res.data?.isFirst ?? false,
      isLast: res.data?.isLast ?? false,
      nextpage: nextPage,
      error: res.error,
    );
    return res;
  }

  myFetchSingelList(List<T> list) {
    fetchResponse(
      list: list,
      isFirst: true,
      isLast: true,
      nextpage: 2,
      error: null,
    );
  }
}

class MyAppPagedChildBuilderDelegate<T> extends AppPagedChildBuilderDelegate<T> {
  MyAppPagedChildBuilderDelegate({
    required super.itemBuilder,
    required super.controller,
    Widget Function(void Function())? errorBox,
    super.emptyBox = const AppEmptyBox(
      image: Icon(Icons.error_outline),
      title: 'error box',
    ),
  }) : super(
          loadingWidget: const LoadingWidget(),
          errorBox: errorBox ??
              (void Function() onTap) {
                return const AppEmptyBox();
              },
        );
}

class ChatMyAppPagedChildBuilderDelegate<T> extends AppPagedChildBuilderDelegate<T> {
  ChatMyAppPagedChildBuilderDelegate({
    required super.itemBuilder,
    required super.controller,
    required super.errorBox,
  }) : super(
          emptyBox: const SizedBox(),
          loadingWidget: const LoadingWidget(),
        );

  @override
  WidgetBuilder? get firstPageErrorIndicatorBuilder => (BuildContext context) {
        return Center(
          child: errorBox(
            () => controller.retryLastFailedRequest(),
          ),
        );
      };
}
