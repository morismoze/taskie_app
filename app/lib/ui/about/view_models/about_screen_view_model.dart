import 'package:flutter/foundation.dart';

import '../../../../data/repositories/client_info/client_info_repository.dart';
import '../../../../domain/models/client_info.dart';

class AboutScreenViewModel extends ChangeNotifier {
  AboutScreenViewModel({required ClientInfoRepository clientInfoRepository})
    : _clientInfoRepository = clientInfoRepository;

  final ClientInfoRepository _clientInfoRepository;

  ClientInfo get clientInfo => _clientInfoRepository.clientInfo;
}
