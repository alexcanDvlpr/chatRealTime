import 'package:chat_realtime/global/environment.dart';
import 'package:chat_realtime/models/users_response.dart';
import 'package:chat_realtime/models/usuario.dart';
import 'package:chat_realtime/services/auth_service.dart';
import 'package:http/http.dart' as http;

class UserService {
  Future<List<Usuario>> getUsers() async {
    try {
      final resp = await http.get(
        Uri.parse('${Environment.apiUrl}/users'),
        headers: {
          'Content-Type': 'application/json',
          'x-token': await AuthService.getToken() ?? "",
        },
      );

      final usersResponse = usersResponseFromJson(resp.body);

      return usersResponse.users;
    } catch (e) {
      return [];
    }
  }
}
