import 'package:vortex/models/providers/provider.dart';
import 'package:vortex/models/providers/provider_data.dart';
import 'package:http/http.dart' as http;

class Esp32Provider extends Provider {
  String IP;

  Esp32Provider(this.IP);

  @override
  Future<Object> getValue(ProviderData type, List<String>? data) async {
    final uri = Uri.parse("http//${IP}/${data?.first ?? ""}");
    final res = await http.get(uri);
    
    if (res.statusCode == 200) {
      return res.body;
    } else {
      throw Exception("Failed to load data");
    }
  }

  @override
  Future<void> setValue(ProviderData type, List<String>? data, Object value) async {
    // TODO: implement setValue
    throw UnimplementedError();
  }
}
