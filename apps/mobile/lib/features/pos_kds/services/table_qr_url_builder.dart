import 'package:mobile/core/config.dart';
import 'package:mobile/features/pos_kds/constants/pos.constant.dart';
import 'package:mobile/features/pos_kds/models/table.model.dart';

class TableQrUrlBuilder {
  const TableQrUrlBuilder._();

  static String sideUrl({required TableModel table, required String side}) {
    final baseUri = Uri.parse(AppConfig.frontendBaseUrl.trim());
    return baseUri
        .replace(
          path: PosConstant.TABLE_QR_PATH,
          queryParameters: {
            PosConstant.TABLE_QR_BRANCH_ID_QUERY: table.branch_id,
            PosConstant.TABLE_QR_TABLE_ID_QUERY: table.id,
            PosConstant.TABLE_QR_TABLE_SIDE_ID_QUERY: side,
            PosConstant.TABLE_QR_ORDER_TYPE_QUERY:
                PosConstant.ORDER_TYPE_DINE_IN,
          },
        )
        .toString();
  }
}
