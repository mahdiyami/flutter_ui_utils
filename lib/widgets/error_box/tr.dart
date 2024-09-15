import 'package:json_annotation/json_annotation.dart';

part 'tr.g.dart';

@JsonSerializable()
class ErrorBoxTr {
  final String titleErrorBoxTr;
  final String descriptionErrorBoxTr;
  final String lableButtonErrorBoxTr;
  final String noProductsFoundErrorBoxTr;
  final String noProformaInvoiceErrorBoxTr;
  final String noProformaInvoiceDescriptionErrorBoxTr;
  final String mainPageTitleErrorBoxTr;
  final String mainPageDescriptionErrorBoxTr;

  const ErrorBoxTr({
    required this.titleErrorBoxTr,
    required this.mainPageDescriptionErrorBoxTr,
    required this.mainPageTitleErrorBoxTr,
    required this.noProformaInvoiceErrorBoxTr,
    required this.noProformaInvoiceDescriptionErrorBoxTr,
    required this.noProductsFoundErrorBoxTr,
    required this.descriptionErrorBoxTr,
    required this.lableButtonErrorBoxTr,
  });

  Map<String, String> toJson() {
    return _$ErrorBoxTrToJson(this).map((key, value) => MapEntry(key, value.toString()));
  }
}
