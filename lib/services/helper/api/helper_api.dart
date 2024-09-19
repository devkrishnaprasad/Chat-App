import 'package:chat_app/services/api/api_provider.dart';

class HelperApiService {
  ApiProvider apiProvider = ApiProvider();
  getCountryList() async {
    return await apiProvider.getRequest('https://restcountries.com/v3.1/all');
  }
}
